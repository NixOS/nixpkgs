{
  lib,
  stdenv,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "flutter_volume_controller";
  inherit version src;
  inherit (src) passthru;

  postPatch = lib.optionalString (lib.versionAtLeast version "1.2.0") ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "# Include ALSA" "find_package(PkgConfig REQUIRED)" \
      --replace-fail "find_package(ALSA REQUIRED)" "pkg_check_modules(ALSA REQUIRED alsa)"
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
