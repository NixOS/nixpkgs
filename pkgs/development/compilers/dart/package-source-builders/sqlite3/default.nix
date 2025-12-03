{
  stdenv,
  lib,
  writeScript,
  sqlite,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "sqlite3";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "${pname}-setup-hook" ''
    sqliteFixupHook() {
      runtimeDependencies+=('${lib.getLib sqlite}')
    }

    preFixupHooks+=(sqliteFixupHook)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ln -s '${src}'/* "$out"

    runHook postInstall
  '';
}
