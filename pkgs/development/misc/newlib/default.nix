{ stdenv, fetchurl, buildPackages }:

let version = "3.1.0";
in stdenv.mkDerivation {
  pname = "newlib";
  inherit version;
  src = fetchurl {
    url = "ftp://sourceware.org/pub/newlib/newlib-${version}.tar.gz";
    sha256 = "0ahh3n079zjp7d9wynggwrnrs27440aac04340chf1p9476a2kzv";
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
    "--enable-newlib-io-long-long"
    "--enable-newlib-register-fini"
    "--enable-newlib-retargetable-locking"
  ];

  dontDisableStatic = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
}
