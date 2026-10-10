{
  stdenv,
  lib,
  writeScript,
  fetchurl,
  sqlite,
}:
{ version, src, ... }:
let
  system-alias = {
    aarch64-linux = "arm64.linux";
    x86_64-linux = "x64.linux";
  };

  precompiled =
    name: hashes:
    stdenv.mkDerivation {
      name = "${name}.so";
      src = fetchurl {
        url = "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-${version}/${name}.${
          system-alias.${stdenv.hostPlatform.system} or (throw ''
            Unsupported system for pub 'sqlite3' ('${name}' dependency)
            Please add the system alias mapping if it exists, note that you will also have to add used version hashes for that system below'')
        }.so";
        sha256 =
          hashes.${"_" + (lib.replaceStrings [ "." ] [ "_" ] version) + "-" + stdenv.hostPlatform.system}
            or (throw ''
              Unsupported version of pub 'sqlite3' ('${name}' dependency '${version}')
              Please add sha256 here. If the sha256
              is the same with existing versions, add an alias here.
            '');
      };
      unpackPhase = ":";
      installPhase = "mkdir -p $out/lib && cp $src $out/lib/${name}.so";
    };

  sqlcipher = precompiled "libsqlcipher" {
    _3_7_0-aarch64-linux = "sha256-XzJyz2ThlbdsvsiORjJuTO2bzi4YbUuwqvC/dspnLvA=";
    _3_7_0-x86_64-linux = "sha256-ncTXhpLnz7shUSvmBkmLknrRpxPAexho/wMEp1Sja3I=";
    _3_6_0-aarch64-linux = "sha256-MHt26xqayuRRfM6iJTAiC6Pe7ez7FuWiY1ZLaqEwwp8=";
    _3_6_0-x86_64-linux = "sha256-zQkSbJ6FGR8rT1fmwLzSMsdIH1b7HWWbeTdMytIb/vk=";
    _3_5_0-aarch64-linux = "sha256-m2Op1KowdxErQ9nFa1+0TIshwjBSdXdrnlsyO4mULos=";
    _3_5_0-x86_64-linux = "sha256-GH+3MhYXTwWD7WmEHzc8wecYcaOcCXsy93UWiEjh6Eo=";
  };

  sqlite3mc = precompiled "libsqlite3mc" {
    _3_7_0-aarch64-linux = "sha256-4Jf49FK79nnUIg2ASB/muMpflVpV+oENRSTXgww0ezk=";
    _3_7_0-x86_64-linux = "sha256-Pf6LzQDjTHBd4UrNHBoNKDuf19IPvUmwqgGWuFodd0E=";
    _3_6_0-aarch64-linux = "sha256-klI2qmyT034nzL4JHJjQS3lZH43DAeaoXbFdLmjB1VA=";
    _3_6_0-x86_64-linux = "sha256-yXyIx4h3K4asxyZrSOGrdnka19Be3TT9m6z3bq6weRw=";
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
      ${lib.optionalString (lib.versionAtLeast version "3.6.0") "runtimeDependencies+=('${lib.getLib sqlite3mc}')"}
    }

    preFixupHooks+=(sqliteFixupHook)
  '';

  postPatch =
    (
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
        ''
    )
    + lib.optionalString (lib.versionAtLeast version "3.6.0") ''
      substituteInPlace lib/src/hook/compile/description.dart \
        --replace-fail "return fromGitHub(LibraryType.sqlite3mc);" "return LookupSystem('sqlite3mc');"
    '';

  installPhase = ''
    runHook preInstall

    cp --recursive . "$out"

    runHook postInstall
  '';
})
