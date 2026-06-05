{
  stdenv,
  lib,
  writeScript,
  sqlite,
}:

{ version, src, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite3";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "${finalAttrs.pname}-setup-hook" ''
    sqliteFixupHook() {
      runtimeDependencies+=('${lib.getLib sqlite}')
    }

    preFixupHooks+=(sqliteFixupHook)
  '';

  postPatch = lib.optionalString (lib.versionAtLeast version "3.2.0") ''
    substituteInPlace lib/src/hook/description.dart \
      --replace-fail "return PrecompiledFromGithubAssets(LibraryType.sqlite3);" "return LookupSystem('sqlite3');"
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive . "$out"

    runHook postInstall
  '';
})
