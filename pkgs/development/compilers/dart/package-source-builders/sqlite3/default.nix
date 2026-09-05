{
  stdenv,
  lib,
  writeScript,
  fetchurl,
  sqlite,
}:
{ version, src, ... }:
let
  sqlcipher =
    let
      system-alias = {
        x86_64-linux = "x64.linux";
      };
    in
    stdenv.mkDerivation {
      name = "libsqlcipher.so";
      src = fetchurl {
        url = "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-${version}/libsqlcipher.${
          system-alias.${stdenv.hostPlatform.system} or (throw ''
            Unsupported system for pub 'sqlite3' ('sqlcipher' dependency)
            Please add the system alias mapping if it exists, note that you will also have to add used version hashes for that system below'')
        }.so";
        sha256 =
          {
            _3_5_0-x86_64-linux = "sha256-GH+3MhYXTwWD7WmEHzc8wecYcaOcCXsy93UWiEjh6Eo=";
          }
          .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version) + "-" + stdenv.hostPlatform.system}
            or (throw ''
              Unsupported version of pub 'sqlite3' ('sqlcipher' dependency '${version}')
              Please add sha256 here. If the sha256
              is the same with existing versions, add an alias here.
            '');
      };
      unpackPhase = ":";
      installPhase = "mkdir -p $out/lib && cp $src $out/lib/libsqlcipher.so";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite3";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "${finalAttrs.pname}-setup-hook" ''
    sqliteFixupHook() {
      runtimeDependencies+=('${lib.getLib sqlite}')
      ${lib.optionalString (lib.versionAtLeast version "3.5.0") "runtimeDependencies+=('${lib.getLib sqlcipher}')"}
    }

    preFixupHooks+=(sqliteFixupHook)
  '';

  postPatch =
    if lib.versionAtLeast version "3.5.0" then
      ''
        substituteInPlace lib/src/hook/compile/description.dart \
          --replace-fail "return fromGitHub(LibraryType.sqlite3);" "return LookupSystem('sqlite3');"

        substituteInPlace lib/src/hook/compile/description.dart \
          --replace-fail "return fromGitHub(LibraryType.sqlcipher);" "return LookupSystem('sqlcipher');"
      ''
    else
      lib.optionalString (lib.versionAtLeast version "3.2.0") ''
        substituteInPlace lib/src/hook/description.dart \
          --replace-fail "return PrecompiledFromGithubAssets(LibraryType.sqlite3);" "return LookupSystem('sqlite3');"
      '';

  installPhase = ''
    runHook preInstall

    cp --recursive . "$out"

    runHook postInstall
  '';
})
