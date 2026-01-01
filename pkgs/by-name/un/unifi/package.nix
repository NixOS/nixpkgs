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
<<<<<<< HEAD
  version = "10.0.162";
=======
  version = "10.0.156";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # see https://community.ui.com/releases / https://www.ui.com/download/unifi
  src = fetchurl {
    url = "https://dl.ui.com/unifi/${finalAttrs.version}/unifi_sysvinit_all.deb";
<<<<<<< HEAD
    hash = "sha256-1wuI6Dg/cKBEhtcoLipXa1q4UiKtqOpRAc8FF0dY5T4=";
=======
    hash = "sha256-FlWsCAH6HN7HzoTLJET36FhGi/ci52jSP7132ayKvpA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://www.ui.com";
    description = "Controller for Ubiquiti UniFi access points";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.unfree;
=======
  meta = with lib; {
    homepage = "https://www.ui.com";
    description = "Controller for Ubiquiti UniFi access points";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      globin
      patryk27
    ];
  };
})
