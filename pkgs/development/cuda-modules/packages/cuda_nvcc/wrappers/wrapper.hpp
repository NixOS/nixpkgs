// What the nvcc and nvlink wrappers share: how they read options files, find the tool they wrap, and run it; see
// README.md.

#pragma once

#include <cerrno>
#include <csignal>
#include <cstring>
#include <fcntl.h>
#include <filesystem>
#include <iostream>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <system_error>
#include <unistd.h>
#include <utility>
#include <vector>

namespace wrapper {

using namespace std::literals;

struct Error : std::runtime_error {
    using std::runtime_error::runtime_error;
};

// Splits an options file into arguments the way nvcc and nvlink do: arguments are separated by whitespace, double
// quotes group, and a backslash escapes the next character. They drop escaped double quotes as well.
inline std::vector<std::string> tokenize(std::string_view contents) {
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

// Returns the real tool, named name, next to the wrapper wherever the wrapper is installed, copied, or linked from.
inline std::string wrapped(std::string_view name) {
    std::error_code error;
    const auto self = std::filesystem::read_symlink("/proc/self/exe", error);
    if (error) throw Error("cannot find the wrapper: " + error.message());
    return self.parent_path() / name;
}

// Whether the wrapper is in the foreground process group of its controlling terminal.
inline bool inForeground() {
    const int tty = open("/dev/tty", O_RDONLY | O_NOCTTY | O_CLOEXEC);
    if (tty < 0) return false;
    const bool foreground = tcgetpgrp(tty) == getpgrp();
    static_cast<void>(::close(tty));
    return foreground;
}

// Runs the real tool, which errors call name, with argv and returns its wait status.
inline int run(std::string_view name, const std::string &tool, char **argv) {
    // An ignored SIGCHLD, which is inherited, would let the kernel reap the tool without telling the wrapper.
    static_cast<void>(std::signal(SIGCHLD, SIG_DFL));
    // Receive the signals to forward, and SIGCHLD, synchronously rather than in a handler.
    sigset_t signals;
    sigset_t original;
    sigemptyset(&signals);
    for (const int sig : {SIGHUP, SIGINT, SIGQUIT, SIGTERM, SIGUSR1, SIGUSR2, SIGCHLD}) sigaddset(&signals, sig);
    sigprocmask(SIG_BLOCK, &signals, &original);

    // In the foreground of a terminal, the tool stays in the wrapper's process group, so that it receives the signals
    // from the terminal itself and the wrapper doesn't forward them. Otherwise the tool gets a process group of its
    // own, so that a signal sent to the wrapper's process group (e.g. by timeout) reaches the tool once, by being
    // forwarded.
    const bool foreground = inForeground();
    const pid_t parent = getpid();
    const pid_t child = fork();
    if (child < 0) throw Error("fork: "s + std::strerror(errno));
    if (child == 0) {
        // Don't outlive the wrapper.
        if (prctl(PR_SET_PDEATHSIG, SIGKILL) != 0 || getppid() != parent) _exit(127);
        if (!foreground && setpgid(0, 0) != 0) _exit(127);
        sigprocmask(SIG_SETMASK, &original, nullptr);
        // Keep argv[0], which the tool reports as its name.
        execv(tool.c_str(), argv);
        std::cerr << name << " wrapper: error: execv " << tool << ": " << std::strerror(errno) << '\n';
        _exit(127);
    }

    for (;;) {
        siginfo_t info;
        if (sigwaitinfo(&signals, &info) < 0) continue; // EINTR
        if (info.si_signo != SIGCHLD) {
            if (!foreground || info.si_code != SI_KERNEL) kill(child, info.si_signo);
            continue;
        }
        int status = 0;
        if (waitpid(child, &status, WNOHANG) == child) {
            sigprocmask(SIG_SETMASK, &original, nullptr);
            return status;
        }
    }
}

} // namespace wrapper
