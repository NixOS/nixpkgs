{ lib, stdenv, fetchurl, buildPackages, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "apr";
  version = "1.7.4";

  src = fetchurl {
    url = "mirror://apache/apr/${pname}-${version}.tar.bz2";
    sha256 = "sha256-/GSN6YPzoqbJ543qHxgGOb0vrWwG1VbUNnpwH+XDVXc=";
  };

  patches = [
    ./cross-assume-dev-zero-mmappable.patch
  ];

  # This test needs the net
  postPatch = ''
    rm test/testsock.*
  '';

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  preConfigure =
    ''
      configureFlagsArray+=("--with-installbuilddir=$dev/share/build")
    '';

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # For cross builds, provide answers to the configure time tests.
    # These answers are valid on x86_64-linux and aarch64-linux.
    "ac_cv_file__dev_zero=yes"
    "ac_cv_func_setpgrp_void=yes"
    "apr_cv_tcp_nodelay_with_cork=yes"
    "ac_cv_define_PTHREAD_PROCESS_SHARED=yes"
    "apr_cv_process_shared_works=yes"
    "apr_cv_mutex_robust_shared=yes"
    "ap_cv_atomic_builtins=yes"
    "apr_cv_mutex_recursive=yes"
    "apr_cv_epoll=yes"
    "apr_cv_epoll_create1=yes"
    "apr_cv_dup3=yes"
    "apr_cv_accept4=yes"
    "apr_cv_sock_cloexec=yes"
    "ac_cv_struct_rlimit=yes"
    "ac_cv_func_sem_open=yes"
    "ac_cv_negative_eai=yes"
    "apr_cv_gai_addrconfig=yes"
    "ac_cv_o_nonblock_inherited=no"
    "apr_cv_pthreads_lib=-lpthread"
    "CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/cc"
  ] ++ lib.optionals (stdenv.hostPlatform.system == "i686-cygwin") [
    # Including the Windows headers breaks unistd.h.
    # Based on ftp://sourceware.org/pub/cygwin/release/libapr1/libapr1-1.3.8-2-src.tar.bz2
    "ac_cv_header_windows_h=no"
  ];

  # - Update libtool for macOS 11 support
  # - Regenerate for cross fix patch
  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://apr.apache.org/";
    description = "The Apache Portable Runtime library";
    mainProgram = "apr-1-config";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.eelco ];
  };
}
