{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libb64";
  version = "2.0.0.1";

  src = fetchFromGitHub {
    owner = "libb64";
    repo = "libb64";
    rev = "v${version}";
    sha256 = "sha256-9loDftr769qnIi00MueO86kjha2EiG9pnCLogp0Iq3c=";
  };

  installPhase = ''
    mkdir -p $out $out/lib $out/bin $out/include
    cp -r include/* $out/include/
    cp base64/base64 $out/bin/
    cp src/libb64.a src/cencode.o src/cdecode.o $out/lib/
  '';

  meta = {
    description = "ANSI C routines for fast base64 encoding/decoding";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
  };
}
