{
  lib,
  stdenv,
  fetchFromGitHub,
}:

# Testing this requires a Thinkpad or the presence of /proc/acpi/ibm/fan
stdenv.mkDerivation {
  pname = "zcfan";
  version = "1.4.0-unstable-2025-12-19";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "zcfan";
    rev = "b4c49eb16d34123d3259fed35f62b48d1afbd1a3";
    hash = "sha256-odO2blW3QeImHB8WShIQ3pLELkGhrhkOTVEQXcJbH/s=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "/usr/local" $out
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/zcfan -h

    runHook postInstallCheck
  '';

  meta = {
    description = "Zero-configuration fan daemon for ThinkPads";
    mainProgram = "zcfan";
    homepage = "https://github.com/cdown/zcfan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      kashw2
    ];
    platforms = lib.platforms.linux;
  };
}
