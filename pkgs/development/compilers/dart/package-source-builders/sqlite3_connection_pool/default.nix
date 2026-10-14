{ stdenv }:
{ version, src, ... }:

stdenv.mkDerivation {
  pname = "sqlite3_connection_pool";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    rm -f hook/build.dart
  '';

  installPhase = ''
    runHook preInstall
    cp --recursive . "$out"
    runHook postInstall
  '';
}
