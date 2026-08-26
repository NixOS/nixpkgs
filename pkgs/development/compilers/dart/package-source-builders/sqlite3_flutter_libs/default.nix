{
  lib,
  stdenv,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "sqlite3_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  postPatch =
    # Upstream 0.6.0 reworked the Linux side to build without the
    # FetchContent download this override replaces; revisit when a lockfile
    # first pins >= 0.6.0.
    lib.optionalString (lib.versionOlder version "0.6.0") ''
      cp ${./CMakeLists.txt} linux/CMakeLists.txt
    ''
    # The darwin pod is a Swift registration stub: the actual sqlite3 library
    # comes from the `sqlite3` package (LookupSystem) on macOS, so the CocoaPods
    # sqlite3 pod dependencies have no counterpart in nixpkgs and are dropped
    # here.  (nixpkgs never builds the iOS side, which ships unchanged.)
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      sed -i "/\.dependency ['\"]sqlite3/d" darwin/sqlite3_flutter_libs.podspec
    '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
