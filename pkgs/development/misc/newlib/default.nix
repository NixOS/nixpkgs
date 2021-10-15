{ stdenv, fetchurl, buildPackages
, # "newlib-nano" is what the official ARM embedded toolchain calls this build
  # configuration that prioritizes low space usage. We include it as a preset
  # for embedded projects striving for a similar configuration.
  nanoizeNewlib ? false
}:

stdenv.mkDerivation rec {
  pname = "newlib";
  version = "4.1.0";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/newlib/newlib-${version}.tar.gz";
    sha256 = "0m01sjjyj0ib7bwlcrvmk1qkkgd66zf1dhbw716j490kymrf75pj";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [ "build" "target" ];
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"

    "--disable-newlib-supplied-syscalls"
    "--disable-nls"
    "--enable-newlib-retargetable-locking"
  ] ++ (if !nanoizeNewlib then [
    "--enable-newlib-io-long-long"
    "--enable-newlib-register-fini"
  ] else [
    "--enable-newlib-reent-small"
    "--disable-newlib-fvwrite-in-streamio"
    "--disable-newlib-fseek-optimization"
    "--disable-newlib-wide-orient"
    "--enable-newlib-nano-malloc"
    "--disable-newlib-unbuf-stream-opt"
    "--enable-lite-exit"
    "--enable-newlib-global-atexit"
    "--enable-newlib-nano-formatted-io"
  ]);

  dontDisableStatic = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
}
