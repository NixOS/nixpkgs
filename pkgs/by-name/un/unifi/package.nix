{
  lib,
  stdenv,
  dpkg,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "unifi-controller";
  version = "8.6.9";

  # see https://community.ui.com/releases / https://www.ui.com/download/unifi
  src = fetchurl {
    url = "https://dl.ui.com/unifi/${version}/unifi_sysvinit_all.deb";
    hash = "sha256-004ZJEoj23FyFEBznqrpPzQ9E6DYpD7gBxa3ewSunIo=";
  };

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cd ./usr/lib/unifi
    cp -ar dl lib webapps $out

    runHook postInstall
  '';

  passthru.tests = {
    unifi = nixosTests.unifi;
  };

  meta = with lib; {
    homepage = "http://www.ubnt.com/";
    description = "Controller for Ubiquiti UniFi access points";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      globin
      patryk27
    ];
  };
}
