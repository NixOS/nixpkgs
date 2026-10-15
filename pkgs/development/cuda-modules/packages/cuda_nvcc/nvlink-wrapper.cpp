// Wrapper for nvlink which removes references to the Nix store from the command line nvlink records in its output; see
// README.md. NVLINK_WRAPPED, the path of the real nvlink, must be defined when compiling.

#include <algorithm>
#include <array>
#include <cerrno>
#include <csignal>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <elf.h>
#include <fstream>
#include <iostream>
#include <iterator>
#include <optional>
#include <ranges>
#include <span>
#include <stdexcept>
#include <string>
#include <string_view>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#include <utility>
#include <vector>

namespace {

using namespace std::literals;

struct Error : std::runtime_error {
    using std::runtime_error::runtime_error;
};

// Overwrites with spaces each hash of a path in the Nix store (32 characters of Nix's base-32 alphabet), which is what
// Nix looks for to find references, whatever the spelling of the path. Returns whether text changed.
bool blankHashes(std::span<char> text) {
    bool changed = false;
    std::size_t run = 0;
    for (std::size_t i = 0; i < text.size(); i++) {
        run = "0123456789abcdfghijklmnpqrsvwxyz"sv.contains(text[i]) ? run + 1 : 0;
        if (run == 32) {
            std::ranges::fill(text.subspan(i - 31, 32), ' ');
            changed = true;
            run = 0;
        }
    }
    return changed;
}

// Returns the n bytes at offset off of bytes, or throws: std::span::subspan doesn't check its arguments.
std::span<char> slice(std::span<char> bytes, std::uint64_t off, std::uint64_t n) {
    if (off > bytes.size() || n > bytes.size() - off) throw Error("the output is a malformed ELF file");
    return bytes.subspan(off, n);
}

template <typename T> T read(std::span<char> bytes, std::uint64_t off) {
    T value{};
    std::memcpy(&value, slice(bytes, off, sizeof(T)).data(), sizeof(T));
    return value;
}

// Splits an options file into arguments the way nvlink does: arguments are separated by whitespace, double quotes
// group, and a backslash escapes the next character. nvlink drops escaped double quotes as well.
std::vector<std::string> tokenize(std::string_view contents) {
    std::vector<std::string> args;
    std::optional<std::string> arg;
    bool quoted = false;
    bool escaped = false;
    for (const char c : contents) {
        if (!escaped && c == '\\') {
            escaped = true;
        } else if (!escaped && c == '"') {
            quoted = !quoted;
            if (!arg) arg.emplace();
        } else if (!escaped && !quoted && " \t\n\r\f\v"sv.contains(c)) {
            if (arg) args.push_back(*std::exchange(arg, std::nullopt));
        } else {
            if (!arg) arg.emplace();
            if (c != '"') *arg += c;
            escaped = false;
        }
    }
    if (escaped || quoted) throw Error("an options file ends in a backslash or a quotation");
    if (arg) args.push_back(*arg);
    return args;
}

// Returns the output (the last -o), including those in options files (comma-separated lists of files of arguments),
// which nvcc uses for long command lines. This is the only part of nvlink's interface the wrapper depends on.
std::optional<std::string> findOutput(std::span<const std::string> args, int depth = 0) {
    if (depth == 16) throw Error("options files are nested too deeply");
    constexpr std::array<std::pair<std::string_view, bool>, 4> options{
        {{"-o", true}, {"--output-file", true}, {"-optf", false}, {"--options-file", false}}};
    std::optional<std::string> output;
    for (std::size_t i = 0; i < args.size(); i++) {
        for (const auto &[name, isOutput] : options) {
            const std::string_view arg = args[i];
            if (!arg.starts_with(name) || (arg.size() != name.size() && arg[name.size()] != '=')) continue;
            if (arg.size() == name.size() && i + 1 == args.size()) throw Error(args[i] + " is missing its value");
            const std::string value = arg.size() == name.size() ? args[++i] : args[i].substr(name.size() + 1);
            if (isOutput) {
                output = value;
                break;
            }
            for (const auto part : std::views::split(value, ',')) {
                const std::string path(part.begin(), part.end());
                if (path.empty()) continue;
                // nvlink reads the options file again, so it can't be a pipe.
                struct stat info{};
                if (stat(path.c_str(), &info) != 0 || !S_ISREG(info.st_mode))
                    throw Error("options file " + path + " is missing or not a regular file");
                std::ifstream file(path);
                if (!file) throw Error("cannot read options file " + path);
                const std::string contents(std::istreambuf_iterator<char>(file), {});
                if (auto nested = findOutput(tokenize(contents), depth + 1)) output = std::move(nested);
            }
            break;
        }
    }
    return output;
}

// Blanks the hashes in the output's .note.nv.tkinfo sections; the output's size and layout are unchanged. Returns
// whether the output changed.
bool scrub(std::span<char> output) {
    if (!std::string_view(output).starts_with(ELFMAG)) {
        // E.g. a host linker script, from -ghls.
        if (std::vector<char> copy(output.begin(), output.end()); blankHashes(copy))
            throw Error("the output isn't an ELF file, but refers to the Nix store");
        return false;
    }
    const auto ehdr = read<Elf64_Ehdr>(output, 0);
    if (ehdr.e_ident[EI_CLASS] != ELFCLASS64 || ehdr.e_ident[EI_DATA] != ELFDATA2LSB ||
        ehdr.e_shentsize != sizeof(Elf64_Shdr))
        throw Error("the output isn't a 64-bit little-endian ELF file");
    // With many sections, the number of sections and the index of the section names are in the first section header.
    const auto first = read<Elf64_Shdr>(output, ehdr.e_shoff);
    const std::uint64_t count = ehdr.e_shnum != 0 ? ehdr.e_shnum : first.sh_size;
    const std::uint64_t namesIndex = ehdr.e_shstrndx != SHN_XINDEX ? ehdr.e_shstrndx : first.sh_link;
    const auto headers = slice(output, ehdr.e_shoff, count * sizeof(Elf64_Shdr));
    const auto section = [&](std::uint64_t i) { return read<Elf64_Shdr>(headers, i * sizeof(Elf64_Shdr)); };
    const auto namesHeader = section(namesIndex);
    const std::string_view names(slice(output, namesHeader.sh_offset, namesHeader.sh_size));

    bool changed = false;
    for (std::uint64_t i = 0; i < count; i++) {
        const auto shdr = section(i);
        if (names.substr(shdr.sh_name).starts_with(".note.nv.tkinfo\0"sv))
            changed |= blankHashes(slice(output, shdr.sh_offset, shdr.sh_size));
    }
    return changed;
}

#ifndef NVLINK_WRAPPER_NO_MAIN

// Runs the real nvlink with argv and returns its wait status.
int run(char **argv) {
    // An ignored SIGCHLD, which is inherited, would let the kernel reap nvlink without telling the wrapper.
    static_cast<void>(std::signal(SIGCHLD, SIG_DFL));
    // Receive the signals to forward, and SIGCHLD, synchronously rather than in a handler.
    sigset_t signals;
    sigset_t original;
    sigemptyset(&signals);
    for (const int sig : {SIGHUP, SIGINT, SIGQUIT, SIGTERM, SIGUSR1, SIGUSR2, SIGCHLD}) sigaddset(&signals, sig);
    sigprocmask(SIG_BLOCK, &signals, &original);

    const pid_t parent = getpid();
    const pid_t child = fork();
    if (child < 0) throw Error("fork: "s + std::strerror(errno));
    if (child == 0) {
        // Don't outlive the wrapper.
        if (prctl(PR_SET_PDEATHSIG, SIGKILL) != 0 || getppid() != parent) _exit(127);
        sigprocmask(SIG_SETMASK, &original, nullptr);
        // Keep argv[0], whose basename nvlink records as the tool name.
        execv(NVLINK_WRAPPED, argv);
        std::cerr << "nvlink wrapper: error: execv " NVLINK_WRAPPED ": " << std::strerror(errno) << '\n';
        _exit(127);
    }

    for (;;) {
        siginfo_t info;
        if (sigwaitinfo(&signals, &info) < 0) continue; // EINTR
        if (info.si_signo != SIGCHLD) {
            // Signals from the terminal reach nvlink as well, being in the same process group; forward the others.
            if (info.si_code != SI_KERNEL) kill(child, info.si_signo);
            continue;
        }
        int status = 0;
        if (waitpid(child, &status, WNOHANG) == child) {
            sigprocmask(SIG_SETMASK, &original, nullptr);
            return status;
        }
    }
}

#endif

} // namespace

#ifndef NVLINK_WRAPPER_NO_MAIN

int main(int argc, char **argv) {
    std::optional<std::string> output;
    bool written = false;
    try {
        const auto args = std::span(argv, static_cast<std::size_t>(argc)).subspan(1);
        output = findOutput(std::vector<std::string>(args.begin(), args.end()));

        // The output is read back after nvlink writes it, so it can't be a pipe or a device.
        struct stat before{};
        const bool existed = output && stat(output->c_str(), &before) == 0;
        if (existed && !S_ISREG(before.st_mode)) throw Error(*output + " is not a regular file");

        const int status = run(argv);
        if (WIFSIGNALED(status)) {
            // Terminate with the same signal.
            static_cast<void>(std::signal(WTERMSIG(status), SIG_DFL));
            static_cast<void>(std::raise(WTERMSIG(status)));
            return 128 + WTERMSIG(status);
        }
        if (WEXITSTATUS(status) != 0) return WEXITSTATUS(status);
        if (!output) return 0; // e.g. --version

        // Touch only what nvlink wrote: if the wrapper and nvlink disagree on the output, fail rather than leak.
        struct stat after{};
        const auto same = [](const timespec &a, const timespec &b) {
            return a.tv_sec == b.tv_sec && a.tv_nsec == b.tv_nsec;
        };
        if (stat(output->c_str(), &after) != 0 ||
            (existed && after.st_ino == before.st_ino && same(after.st_mtim, before.st_mtim) &&
             same(after.st_ctim, before.st_ctim)))
            throw Error("nvlink didn't write " + *output);

        written = true;
        std::fstream file(*output, std::ios::binary | std::ios::in | std::ios::out);
        std::vector<char> contents{std::istreambuf_iterator<char>(file), {}};
        if (!file.is_open() || file.bad()) throw Error("cannot read " + *output);
        if (scrub(contents)) {
            file.clear();
            file.seekp(0).write(contents.data(), static_cast<std::streamsize>(contents.size()));
            file.close();
            if (!file) throw Error("cannot write " + *output);
        }
        return 0;
    } catch (const std::exception &e) {
        std::cerr << "nvlink wrapper: error: " << e.what() << '\n';
        // Don't leave behind an output which looks complete.
        if (written) static_cast<void>(std::remove(output->c_str()));
        return 1;
    }
}

#endif
