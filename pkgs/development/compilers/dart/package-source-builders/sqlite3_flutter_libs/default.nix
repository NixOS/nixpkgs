{
  stdenv,
  lib,
  fetchurl,
}:

{ version, src, ... }:

let
  sqlite-autoconf = fetchurl {
    url = "https://sqlite.org/2024/sqlite-autoconf-3470000.tar.gz";
    hash = "sha256-g+shpvamSfUG34vTqrhaCPdVbO7V29jep0PqAD/DqVc=";
  };
in
stdenv.mkDerivation {
  pname = "sqlite3_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-warn "https://sqlite.org/2024/sqlite-autoconf-3470000.tar.gz" "file://${sqlite-autoconf}" \
      --replace-warn "https://sqlite.org/2024/sqlite-autoconf-3460000.tar.gz" "file://${sqlite-autoconf}"
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -a ./* $out/

    runHook postInstall
  '';
}
