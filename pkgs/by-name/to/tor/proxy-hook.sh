_setupTorProxy(){
    local torSocket=$NIX_BUILD_TOP/.tor.sock
    local torPort=unix:$torSocket

    exec {tor_fd}< <(@tor@ --DataDirectory "$NIX_BUILD_TOP/.tor" --SocksPort "$torPort")
    exitHooks+=("kill '$!'")

    # Wait for Tor to start
    read < <(<&$tor_fd- @tee@ /dev/fd/2 | @grep@ -m 1 -F 'Bootstrapped 100% (done): Done')

    export ALL_PROXY="socks5h://localhost$torSocket"

    # A Git repository may have submodules that fetch from clearnet URLs, so
    # for better performance, use Tor only for onion addresses. (fetchgit
    # doesn't respect ALL_PROXY, so this doesn't conflict.)
    export FETCHGIT_HTTP_PROXIES="http://*.onion $ALL_PROXY ${FETCHGIT_HTTP_PROXIES-}"
}

postHooks+=(_setupTorProxy)
