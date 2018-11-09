{ stdenv, fetchurl, buildPackages }:

let version = "3.0.0.20180802";
in stdenv.mkDerivation {
  name = "newlib-${version}";
  src = fetchurl {
    url = "ftp://sourceware.org/pub/newlib/newlib-${version}.tar.gz";
    sha256 = "1xk3h9b28z7yfalckw28lvszf4hxr0xq35gjr78pi5ipy514ni45";
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
