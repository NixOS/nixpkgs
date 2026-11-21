{
  stdenv,
  lib,
  writeScript,
  fetchurl,
  sqlite,
  sqlcipher,
  targetFlutterPlatform ? null,
}:
{ version, src, ... }:
let
  sqlcipherLibrary =
    if stdenv.hostPlatform.isDarwin then
      sqlcipher
    else
      let
        system-alias = {
          aarch64-linux = "arm64.linux";
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
              _3_7_0-aarch64-linux = "sha256-XzJyz2ThlbdsvsiORjJuTO2bzi4YbUuwqvC/dspnLvA=";
              _3_7_0-x86_64-linux = "sha256-ncTXhpLnz7shUSvmBkmLknrRpxPAexho/wMEp1Sja3I=";
              _3_5_0-aarch64-linux = "sha256-m2Op1KowdxErQ9nFa1+0TIshwjBSdXdrnlsyO4mULos=";
              _3_5_0-x86_64-linux = "sha256-GH+3MhYXTwWD7WmEHzc8wecYcaOcCXsy93UWiEjh6Eo=";
              _3_5_2-aarch64-linux = "sha256-LMKxM9hJXdCGytVuYSro3iYbMuDwDk6fcqvzVYHD7s0=";
              _3_5_2-x86_64-linux = "sha256-RdsYQ+ujyR16Ip72A7u2o7uavqtDC72V26pAJAxxOAk=";
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
      ${lib.optionalString (lib.versionAtLeast version "3.5.0") "runtimeDependencies+=('${lib.getLib sqlcipherLibrary}')"}
    }

    preFixupHooks+=(sqliteFixupHook)
  '';

  postPatch =
    (
      if lib.versionAtLeast version "3.5.0" then
        ''
          substituteInPlace lib/src/hook/compile/description.dart \
            --replace-fail "return fromGitHub(LibraryType.sqlite3);" "return LookupSystem('${
              if stdenv.hostPlatform.isDarwin then "${lib.getLib sqlite}/lib/libsqlite3.dylib" else "sqlite3"
            }');"

          substituteInPlace lib/src/hook/compile/description.dart \
            --replace-fail "return fromGitHub(LibraryType.sqlcipher);" "return LookupSystem('${
              if stdenv.hostPlatform.isDarwin then
                "${lib.getLib sqlcipherLibrary}/lib/libsqlcipher.dylib"
              else
                "sqlcipher"
            }');"
        ''
      else
        lib.optionalString (lib.versionAtLeast version "3.2.0") ''
          substituteInPlace lib/src/hook/description.dart \
            --replace-fail "return PrecompiledFromGithubAssets(LibraryType.sqlite3);" "return LookupSystem('${
              if stdenv.hostPlatform.isDarwin then "${lib.getLib sqlite}/lib/libsqlite3.dylib" else "sqlite3"
            }');"
        ''
    )
    + lib.optionalString (targetFlutterPlatform == "macos" && lib.versionOlder version "3.0.0") ''
      substituteInPlace lib/src/ffi/load_library.dart \
        --replace-fail 'result = DynamicLibrary.process();' "result = DynamicLibrary.open('${lib.getLib sqlite}/lib/libsqlite3.dylib');" \
        --replace-fail "'/usr/lib/libsqlite3.dylib'" "'${lib.getLib sqlite}/lib/libsqlite3.dylib'"
    '';

  installPhase = ''
    runHook preInstall

    cp --recursive . "$out"

    runHook postInstall
  '';
})
