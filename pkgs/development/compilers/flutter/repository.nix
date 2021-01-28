{ lib, stdenv, dart, fetchurl, src, pname, version, depsSha256 }:

stdenv.mkDerivation {
  inherit src version;

  pname = "${pname}-deps";
  buildInputs = [ dart ];

  buildPhase = ''
    export PUB_CACHE="$out"
    export FLUTTER_ROOT="$(pwd)"
    export FLUTTER_TOOLS_DIR="$FLUTTER_ROOT/packages/flutter_tools"

    pushd "$FLUTTER_TOOLS_DIR"
    ${dart}/bin/pub get
  '';

  dontInstall = true;
  dontFixup = true;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = depsSha256;
}
