{ stdenv, lib, fetchurl, fetchFromGitHub, buildPackages, espressifXtensaOverlays }:
let
  normal-version = "3.3.0";
  normal-src = fetchurl {
    url = "ftp://sourceware.org/pub/newlib/newlib-${normal-version}.tar.gz";
    sha256 = "0ricyx792ig2cb2x31b653yb7w7f7mf2111dv5h96lfzmqz9xpaq";
  };

  xtensa-src = fetchFromGitHub {
    owner = "espressif";
    repo = "newlib-esp32";
    rev = "esp-2020r3";
    sha256 = "1azk8wdx62xpf6jpbxnk21adryyf9airs1xrr0iyhnfm8lhbxir0";
  };

in
stdenv.mkDerivation ((if (with stdenv.targetPlatform; isOr1k || isVc4 || isXtensa) then {
  name = "newlib";
} else {
  pname = "newlib";
  version = normal-version;
}) // {
  src = with stdenv.targetPlatform;
    if isXtensa then xtensa-src
    else default-src;
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
  ] ++ (lib.optional stdenv.targetPlatform.isXtensa [
    "--disable-newlib-io-c99-formats"
    "--disable-newlib-supplied-syscalls"
    "--enable-newlib-nano-formatted-io"
    "--enable-newlib-reent-small"
    "--enable-target-optspace"
    "--enable-newlib-long-time_t"
    "--enable-newlib-nano-malloc"
  ]);

  dontDisableStatic = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
}

// lib.optionalAttrs stdenv.targetPlatform.isXtensa {
  postPatch = ''
    cp -RT ${espressifXtensaOverlays stdenv.targetPlatform}/newlib .
  '';
}
)
