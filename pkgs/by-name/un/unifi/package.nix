{
  lib,
  stdenvNoCC,
  dpkg,
  fetchurl,
  nixosTests,
  systemd,
  autoPatchelfHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unifi-controller";
  version = "9.5.21";

  # see https://community.ui.com/releases / https://www.ui.com/download/unifi
  src = fetchurl {
    url = "https://dl.ui.com/unifi/${finalAttrs.version}/unifi_sysvinit_all.deb";
    hash = "sha256-faHMmrGuDI8wLCQtYi7lL4Z0V6aRFrKqTBOBLnVphq8=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    systemd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -ar usr/lib/unifi/{dl,lib,webapps} $out

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) unifi; };

  meta = {
    homepage = "https://www.ui.com";
    description = "Controller for Ubiquiti UniFi access points";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    knownVulnerabilities = [
      "The following vulnerabilities are fixed in version 9.0.118 and 10.1.89:"
      "CVE-2026-22557 (CVSSv3.1 10.0/Critical)"
      "CVE-2026-22558 (CVSSv3.1 7.7/High)"
      "Version 10.1.89 is packaged in Nixpkgs' unstable branch, and contains some breaking changes compared to this version."
      "Please see https://community.ui.com/releases/Security-Advisory-Bulletin-062-062/c29719c0-405e-4d4a-8f26-e343e99f931b for more information."
    ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      globin
      patryk27
    ];
  };
})
