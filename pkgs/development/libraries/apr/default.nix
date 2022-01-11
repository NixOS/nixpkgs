{ lib, stdenv, fetchurl, fetchpatch, buildPackages, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "apr";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://apache/apr/${pname}-${version}.tar.bz2";
    sha256 = "1spp6r2a3xcl5yajm9safhzyilsdzgagc2dadif8x6z9nbq4iqg2";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-35940.patch";
      url = "https://dist.apache.org/repos/dist/release/apr/patches/apr-1.7.0-CVE-2021-35940.patch";
      sha256 = "1qd511dyqa1b7bj89iihrlbaavbzl6yyblqginghmcnhw8adymbs";
      # convince fetchpatch to restore missing `a/`, `b/` to paths
      extraPrefix = "";
    })

    # Fix cross.
    (fetchpatch {
      url = "https://github.com/apache/apr/commit/374210c50ee9f4dbf265f0172dcf2d45b97d0550.patch";
      sha256 = "04k62c5dh043jhkgs5qma6yqkq4q7nh0zswr81il4l7q1zil581y";
    })
    (fetchpatch {
      url = "https://github.com/apache/apr/commit/866e1df66be6704a584feaf5c3d241e3d631d03a.patch";
      sha256 = "0hhm5v5wx985c28dq6d9ngnyqihpsphq4mw7rwylk39k2p90ppcm";
    })
  ] ++ lib.optionals stdenv.isDarwin [ ./is-this-a-compiler-bug.patch ];

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

  configureFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_file__dev_zero=yes"
    "ac_cv_func_setpgrp_void=0"
    "apr_cv_tcp_nodelay_with_cork=1"
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
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.eelco ];
  };
}
