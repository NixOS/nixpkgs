// Wrapper for nvcc which makes its output reproducible and puts the host compiler on PATH; see README.md. The real nvcc
// is .nvcc-wrapped, next to the wrapper.
//
// NVCC_WRAPPER_COMPILER_BINDIR is the directory of the host compiler. NVCC_WRAPPER_FRANDOM_SEED is 1 if nvcc has
// --frandom-seed (from CUDA 12.9), else 0.

#include "wrapper.hpp"

#include <algorithm>
#include <array>
#include <cerrno>
#include <csignal>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <ranges>
#include <set>
#include <span>
#include <string>
#include <string_view>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <system_error>
#include <unistd.h>
#include <vector>

namespace {

using namespace wrapper;

// What the wrapper needs to know about the options and the source files that nvcc is given.
struct Request {
    // The caller decides where the intermediate files go.
    bool keeps = false;
    // The caller passes a seed.
    bool seeds = false;
    // Two source files have the same name. nvcc names the files that it keeps after the source file, and without -c it
    // keeps the objects in the same directory, so the second object would overwrite the first.
    bool collides = false;
    // The names of the source files, without directory and extension.
    std::set<std::string> stems;
};

// Returns whether arg is the option name, with one or two dashes, alone or followed by =value.
bool isOption(std::string_view arg, std::string_view name) {
    if (!arg.starts_with('-')) return false;
    arg.remove_prefix(arg.starts_with("--") ? 2 : 1);
    return arg.starts_with(name) && (arg.size() == name.size() || arg[name.size()] == '=');
}

// Records in request what args say, including the arguments in options files (comma-separated lists of files of
// arguments).
void scan(std::span<const std::string> args, Request &request, int depth = 0) {
    if (depth == 16) throw Error("options files are nested too deeply");
    constexpr std::array<std::string_view, 4> keep{"keep", "keep-dir", "save-temps", "objdir-as-tempdir"};
    constexpr std::array<std::string_view, 8> sources{".cu", ".c", ".cc", ".cxx", ".cpp", ".c++", ".C", ".CPP"};
    for (std::size_t i = 0; i < args.size(); i++) {
        const std::string_view arg = args[i];
        if (std::ranges::any_of(keep, [&](std::string_view name) { return isOption(arg, name); })) {
            request.keeps = true;
        } else if (isOption(arg, "frandom-seed")) {
            request.seeds = true;
        } else if (isOption(arg, "optf") || isOption(arg, "options-file")) {
            const auto equals = arg.find('=');
            if (equals == arg.npos && i + 1 == args.size()) throw Error(args[i] + " is missing its value");
            const std::string value = equals == arg.npos ? args[++i] : args[i].substr(equals + 1);
            for (const auto part : std::views::split(value, ',')) {
                const std::string path(part.begin(), part.end());
                if (path.empty()) continue;
                // nvcc reads the options file again, so reading a pipe here would leave it empty for nvcc.
                struct stat info{};
                if (stat(path.c_str(), &info) != 0 || !S_ISREG(info.st_mode))
                    throw Error("options file " + path + " is missing or not a regular file");
                std::ifstream file(path);
                if (!file) throw Error("cannot read options file " + path);
                const std::string contents(std::istreambuf_iterator<char>(file), {});
                scan(tokenize(contents), request, depth + 1);
            }
        } else if (!arg.starts_with('-')) {
            const std::filesystem::path path(arg);
            if (std::ranges::find(sources, path.extension().native()) == sources.end()) continue;
            if (!request.stems.insert(path.stem()).second) request.collides = true;
        }
    }
}

// Returns a hash of the working directory and the arguments, as 16 hexadecimal digits (FNV-1a). It is the same when
// the same command runs again in the same directory, as in a rebuild, and different for every source file of a build.
std::string identify(std::span<char *> args) {
    std::uint64_t hash = 0xcbf29ce484222325;
    const auto add = [&](std::string_view text) {
        for (const char c : text) hash = (hash ^ static_cast<unsigned char>(c)) * 0x100000001b3;
        // Separate the arguments, so that "a" "b" and "ab" differ.
        hash *= 0x100000001b3;
    };
    std::error_code error;
    add(std::filesystem::current_path(error).native());
    for (const char *arg : args) add(arg);
    std::array<char, 17> digits{};
    static_cast<void>(std::snprintf(digits.data(), digits.size(), "%016llx", static_cast<unsigned long long>(hash)));
    return digits.data();
}

// Creates the directory for the intermediate files, which only the user may read, and returns whether nvcc can use it.
// The directory can be left over from a run that was killed.
bool createKeepDir(const std::string &dir) {
    if (mkdir(dir.c_str(), 0700) == 0) return true;
    struct stat info{};
    return errno == EEXIST && lstat(dir.c_str(), &info) == 0 && S_ISDIR(info.st_mode) && info.st_uid == geteuid();
}

} // namespace

int main(int argc, char **argv) {
    if (argc < 1) return 127;
    const auto args = std::span(argv, static_cast<std::size_t>(argc)).subspan(1);
    std::string nvcc;
    try {
        nvcc = wrapped(".nvcc-wrapped");
    } catch (const std::exception &e) {
        std::cerr << "nvcc wrapper: error: " << e.what() << '\n';
        return 127;
    }

    // nvcc fails without the host compiler on PATH, even before it reads compiler-bindir from nvcc.profile.
    const char *path = std::getenv("PATH");
    const std::string extended = NVCC_WRAPPER_COMPILER_BINDIR + (path != nullptr && *path != '\0' ? ":"s + path : ""s);
    static_cast<void>(setenv("PATH", extended.c_str(), 1));

    // The options to add. If the wrapper cannot read the command line, it adds none: nvcc then reports the error.
    std::vector<std::string> added;
    std::string keepDir;
    try {
        Request request;
        scan(std::vector<std::string>(args.begin(), args.end()), request);
        // nvcc also reads options from these variables.
        for (const char *name : {"NVCC_PREPEND_FLAGS", "NVCC_APPEND_FLAGS"}) {
            if (const char *flags = std::getenv(name)) {
                std::vector<std::string> words;
                // An approximation of how nvcc splits them, which is enough to find the options.
                for (const auto word : std::views::split(std::string_view(flags), ' '))
                    if (!word.empty()) words.emplace_back(word.begin(), word.end());
                scan(words, request);
            }
        }
        // Without a source file there is nothing to compile, e.g. a link of objects or --version.
        if (!request.stems.empty()) {
            const std::string id = identify(args);
            // NVIDIA requires a different seed for every source file.
            if (NVCC_WRAPPER_FRANDOM_SEED && !request.seeds) added.push_back("--frandom-seed=" + id);
            if (!request.keeps && !request.collides) {
                const char *tmp = std::getenv("TMPDIR");
                // The name must not be random, because it ends up in the debugging information (-g).
                const std::string dir = (tmp != nullptr && *tmp != '\0' ? tmp : "/tmp") + "/nvcc-keep-"s + id;
                if (createKeepDir(dir)) {
                    keepDir = dir;
                    added.emplace_back("--keep");
                    added.push_back("--keep-dir=" + dir);
                }
            }
        }
    } catch (const std::exception &) {
        added.clear();
    }

    // The options of the wrapper come first, because nvcc uses the last value of an option. An option of the caller
    // that the wrapper missed then takes precedence. argv[0] stays, as nvcc reports it as its name.
    std::vector<char *> command{argv[0]};
    for (std::string &option : added) command.push_back(option.data());
    command.insert(command.end(), args.begin(), args.end());
    command.push_back(nullptr);

    if (keepDir.empty()) {
        // There is nothing to remove afterwards.
        execv(nvcc.c_str(), command.data());
        std::cerr << "nvcc wrapper: error: execv " << nvcc << ": " << std::strerror(errno) << '\n';
        return 127;
    }

    int status = 0;
    try {
        status = run("nvcc", nvcc, command.data());
    } catch (const std::exception &e) {
        std::cerr << "nvcc wrapper: error: " << e.what() << '\n';
        status = 127 << 8;
    }
    std::error_code error;
    std::filesystem::remove_all(keepDir, error);
    if (WIFSIGNALED(status)) {
        // Terminate with the same signal.
        static_cast<void>(std::signal(WTERMSIG(status), SIG_DFL));
        static_cast<void>(std::raise(WTERMSIG(status)));
        return 128 + WTERMSIG(status);
    }
    return WEXITSTATUS(status);
}
