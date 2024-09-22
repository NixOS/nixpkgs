{
  stdenv,
  lib,
  fetchurl,
  sqlite,
}:
let
  url = "https://sqlite.org/2024/sqlite-autoconf-3460000.tar.gz";
  src' = fetchurl {
    inherit url;
    hash = "sha256-b45qezNSc3SIFvmztiu9w3Koid6HgtfwSMZTpEdBen0=";
  };

in
{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "sqlite3_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  propagatedBuildInputs = [
    sqlite
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"

    cp -r --reflink=auto '${src}'/* "$out"/

    substituteInPlace "$out/linux/CMakeLists.txt" --replace "${url}" "file://${src'}"

    runHook postInstall
  '';
}
