{ stdenv, fetchurl, fetchFromGitHub, buildPackages }:

let
  xtensa-overlays = fetchFromGitHub {
    owner = "espressif";
    repo = "xtensa-overlays";
    rev = "e9af7626c8a550eb6a422fa5e7903ee912c90539";
    sha256 = "14s3jrngj15xdryg6gggrbl1826x6j86ckmnf447ixzmnf39b404";
  };

  version = if stdenv.targetPlatform.isXtensa then "3.0.0" else "3.3.0";
in stdenv.mkDerivation {
  pname = "newlib";
  inherit version;
  src = if stdenv.targetPlatform.isXtensa then fetchFromGitHub {
    owner = "espressif";
    repo = "newlib-esp32";
    rev = "1590f7fa92e899e86df4774a7f743af19fe077e7";
    sha256 = "0pcs2y81i99niic2i78h0xk2fapmyklpwkxzswmg9dbwyyzpkfrk";
  } else fetchurl {
    url = "ftp://sourceware.org/pub/newlib/newlib-${version}.tar.gz";
    sha256 = "0ricyx792ig2cb2x31b653yb7w7f7mf2111dv5h96lfzmqz9xpaq";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc

    cp -r ${xtensa-overlays}/xtensa_esp32/newlib/* .
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
