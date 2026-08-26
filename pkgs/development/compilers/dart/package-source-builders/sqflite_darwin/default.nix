{
  lib,
  stdenv,
  sqlite,
}:

{ version, src, ... }:

if !stdenv.hostPlatform.isDarwin then
  # The vendored sqlite dylib and sidecar are only consumed by the macOS
  # build; returning the pristine pub sources elsewhere keeps the linux
  # derivations of every sqflite app byte-identical to the unpatched
  # package, avoiding mass rebuilds.
  src
else
  stdenv.mkDerivation {
    pname = "sqflite_darwin";
    inherit version src;
    inherit (src) passthru;

    # sqflite compiles against the system sqlite3 on iOS/macOS, but the
    # nixpkgs SDK has neither sqlite3.h nor libsqlite3.dylib. The nixpkgs
    # `sqlite` package stands in for the CocoaPods sqlite3 pod: headers land
    # next to the pod's public headers (picked up by the collector's -I
    # include search) and the dylib rides along as a vendored library,
    # relinked to @rpath so the app bundles it in Contents/Frameworks and
    # keeps running without the nix store (its own zlib dependency stays an
    # absolute store path, which is fine inside a Nix environment).  The
    # podspec is left untouched (CocoaPods users still get the real sqlite3
    # pod); the library is declared in the nixpkgs-vendored-libraries.txt
    # sidecar instead, which macos-build.py reads.
    postPatch =
      let
        include_dir = "darwin/sqflite_darwin/Sources/sqflite_darwin/include";
      in
      ''
        mkdir -p "${include_dir}/sqlite3"
        cp ${lib.getDev sqlite}/include/sqlite3.h "${include_dir}/"
        cp ${lib.getDev sqlite}/include/sqlite3.h ${lib.getDev sqlite}/include/sqlite3ext.h "${include_dir}/sqlite3/"
        cp -L ${sqlite.out}/lib/libsqlite3.dylib darwin/libsqlite3.dylib
        install_name_tool -id @rpath/libsqlite3.dylib darwin/libsqlite3.dylib
      ''
      # The dylib carries the nixpkgs build's LC_RPATH into the app's
      # closure for no benefit (its zlib dependency is already an absolute
      # store path); drop it so sqflite apps stay self-contained.  Guarded:
      # install_name_tool aborts when the rpath is absent, which would break
      # every sqflite app on an upstream sqlite packaging change.
      + ''
        if otool -l darwin/libsqlite3.dylib | grep -q "${sqlite.out}/lib"; then
          install_name_tool -delete_rpath ${sqlite.out}/lib darwin/libsqlite3.dylib
        fi
        echo "darwin/libsqlite3.dylib" > nixpkgs-vendored-libraries.txt
      '';

    installPhase = ''
      runHook preInstall

      cp -r . $out

      runHook postInstall
    '';
  }
