{
  lib,
  stdenvNoCC,
  dpkg,
  fetchurl,
  nixosTests,
  systemd,
  autoPatchelfHook,
  jdk25_headless,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unifi-controller";
  version = "10.2.105";

  # See https://community.ui.com/releases or https://www.ui.com/download/unifi.
  #
  # When upgrading, make sure we don't need to bump `passthru.jrePackage` below
  # as well.
  src = fetchurl {
    url = "https://dl.ui.com/unifi/${finalAttrs.version}/unifi_sysvinit_all.deb";
    hash = "sha256-MBTFxNwrIbx6UKZYCcZ+BjYjSlfdxL60Ogei/ba4O+U=";
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

  passthru = {
    jrePackage = jdk25_headless;

    tests = {
      inherit (nixosTests) unifi;
    };
  };

  meta = {
    homepage = "https://www.ui.com";
    description = "Controller for Ubiquiti UniFi access points";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
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
