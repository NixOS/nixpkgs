{
  lib,
  stdenv,
  sqlite,
  writeScript,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "sqlite3";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "sqlite3-setup-hook" ''
    sqliteFixupHook() {
      runtimeDependencies+=('${lib.getLib sqlite}')
    }

    preFixupHooks+=(sqliteFixupHook)
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
