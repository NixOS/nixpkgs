{
  lib,
  stdenv,
  sqlite,
  targetFlutterPlatform ? null,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "sqlite3_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  postPatch =
    (lib.optionalString (stdenv.hostPlatform.isLinux && lib.versionOlder version "0.6.0") ''
      cp ${./CMakeLists.txt} linux/CMakeLists.txt
    '')
    + lib.optionalString (targetFlutterPlatform == "macos" && lib.versionOlder version "0.6.0") ''
      # Adapt both upstream build definitions; Flutter selects which one to use.
      # Preload SQLite so the app sandbox does not block a later Dart FFI dlopen.
      for podspec in darwin/sqlite3_flutter_libs.podspec macos/sqlite3_flutter_libs.podspec; do
        if [ -f "$podspec" ]; then
          sed -i \
            -e "/s.dependency 'sqlite3'/c\\    s.osx.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '\$(inherited) -Wl,-needed_library,${lib.getLib sqlite}/lib/libsqlite3.dylib' }" \
            -e "/s.dependency 'sqlite3\\//d" "$podspec"
        fi
      done
      manifest=darwin/sqlite3_flutter_libs/Package.swift
      if [ -f "$manifest" ]; then
        sed -i '\|.package(url: "https://github.com/simolus3/CSQLite.git"|d' "$manifest"
        substituteInPlace "$manifest" \
          --replace-fail 'dependencies: ["CSQLite"],' 'dependencies: [],' \
          --replace-fail 'resources: []' \
            'resources: [], linkerSettings: [.unsafeFlags(["-Wl,-needed_library,${lib.getLib sqlite}/lib/libsqlite3.dylib"])]'
      fi
    '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
