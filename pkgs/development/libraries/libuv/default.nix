{ stdenv
, lib
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkg-config
, pkgsStatic

# for passthru.tests
, bind
, cmake
, knot-resolver
, sbclPackages
, luajitPackages
, mosquitto
, neovim
, nodejs
, ocamlPackages
, python3
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.48.0";
  pname = "libuv";

  src = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U68BmIQNpmIy3prS7LkYl+wvDJQNikoeFiKh50yQFoA=";
  };

  outputs = [ "out" "dev" ];

  postPatch = let
    toDisable = [
      "getnameinfo_basic" "udp_send_hang_loop" # probably network-dependent
      "tcp_connect_timeout" # tries to reach out to 8.8.8.8
      "spawn_setuid_fails" "spawn_setgid_fails" "fs_chown" # user namespaces
      "getaddrinfo_fail" "getaddrinfo_fail_sync" "tcp_connect6_link_local"
      "threadpool_multiple_event_loops" # times out on slow machines
      "get_passwd" # passed on NixOS but failed on other Linuxes
      "tcp_writealot" "udp_multicast_join" "udp_multicast_join6" "metrics_pool_events" # times out sometimes
      "fs_fstat" # https://github.com/libuv/libuv/issues/2235#issuecomment-1012086927

      # Assertion failed in test/test-tcp-bind6-error.c on line 60: r == UV_EADDRINUSE
      # Assertion failed in test/test-tcp-bind-error.c on line 99: r == UV_EADDRINUSE
      "tcp_bind6_error_addrinuse" "tcp_bind_error_addrinuse_listen"
      # https://github.com/libuv/libuv/pull/4075#issuecomment-1935572237
      "thread_priority"
    ] ++ lib.optionals stdenv.isDarwin [
        # Sometimes: timeout (no output), failed uv_listen. Someone
        # should report these failures to libuv team. There tests should
        # be much more robust.
        "process_title" "emfile" "poll_duplex" "poll_unidirectional"
        "ipc_listen_before_write" "ipc_listen_after_write" "ipc_tcp_connection"
        "tcp_alloc_cb_fail" "tcp_ping_pong" "tcp_ref3" "tcp_ref4"
        "tcp_bind6_error_inval" "tcp_bind6_error_addrinuse" "tcp_read_stop"
        "tcp_unexpected_read" "tcp_write_to_half_open_connection"
        "tcp_oob" "tcp_close_accept" "tcp_create_early_accept"
        "tcp_create_early" "tcp_close" "tcp_bind_error_inval"
        "tcp_bind_error_addrinuse" "tcp_shutdown_after_write"
        "tcp_open" "tcp_write_queue_order" "tcp_try_write" "tcp_writealot"
        "multiple_listen" "delayed_accept" "udp_recv_in_a_row"
        "shutdown_close_tcp" "shutdown_eof" "shutdown_twice" "callback_stack"
        "tty_pty" "condvar_5" "hrtime" "udp_multicast_join"
        # Tests that fail when sandboxing is enabled.
        "fs_event_close_in_callback" "fs_event_watch_dir" "fs_event_error_reporting"
        "fs_event_watch_dir_recursive" "fs_event_watch_file"
        "fs_event_watch_file_current_dir" "fs_event_watch_file_exact_path"
        "process_priority" "udp_create_early_bad_bind"
    ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
        # fail on macos < 10.15 (starting in libuv 1.47.0)
        "fs_write_alotof_bufs_with_offset" "fs_write_multiple_bufs" "fs_read_bufs"
    ] ++ lib.optionals stdenv.isAarch32 [
      # I observe this test failing with some regularity on ARMv7:
      # https://github.com/libuv/libuv/issues/1871
      "shutdown_close_pipe"
    ];
    tdRegexp = lib.concatStringsSep "\\|" toDisable;
    in lib.optionalString (finalAttrs.finalPackage.doCheck) ''
      sed '/${tdRegexp}/d' -i test/test-list.h
    '';

  nativeBuildInputs = [ automake autoconf libtool pkg-config ];

  preConfigure = ''
    LIBTOOLIZE=libtoolize ./autogen.sh
  '';

  enableParallelBuilding = true;

  # separateDebugInfo breaks static build
  # https://github.com/NixOS/nixpkgs/issues/219466
  separateDebugInfo = !stdenv.hostPlatform.isStatic;

  doCheck =
    # routinely hangs on powerpc64le
    !stdenv.hostPlatform.isPower64;

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit bind cmake knot-resolver mosquitto neovim nodejs;
    inherit (sbclPackages) cl-libuv;
    luajit-libluv = luajitPackages.libluv;
    luajit-luv = luajitPackages.luv;
    ocaml-luv = ocamlPackages.luv;
    python-pyuv = python3.pkgs.pyuv;
    python-uvloop = python3.pkgs.uvloop;
    static = pkgsStatic.libuv;
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Multi-platform support library with a focus on asynchronous I/O";
    homepage    = "https://libuv.org/";
    changelog   = "https://github.com/libuv/libuv/blob/v${finalAttrs.version}/ChangeLog";
    pkgConfigModules = [ "libuv" ];
    maintainers = [ ];
    platforms   = platforms.all;
    license     = with licenses; [ mit isc bsd2 bsd3 cc-by-40 ];
  };

})
