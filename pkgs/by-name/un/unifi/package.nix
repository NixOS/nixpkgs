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
  version = "9.0.114";

  # see https://community.ui.com/releases / https://www.ui.com/download/unifi
  src = fetchurl {
    url = "https://dl.ui.com/unifi/${finalAttrs.version}/unifi_sysvinit_all.deb";
    hash = "sha256-3xumIIzr+tx60kPhPfSs2Kz2iJ39Kt5934Vca/MpUu4=";
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

  meta = with lib; {
    homepage = "https://www.ui.com";
    description = "Controller for Ubiquiti UniFi access points";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      globin
      patryk27
    ];
  };
})
