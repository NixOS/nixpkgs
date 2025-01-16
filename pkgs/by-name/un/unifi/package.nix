{
  lib,
  stdenv,
  dpkg,
  fetchurl,
  nixosTests,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "unifi-controller";
  version = "9.0.108";

  # see https://community.ui.com/releases / https://www.ui.com/download/unifi
  src = fetchurl {
    url = "https://dl.ui.com/unifi/${version}/unifi_sysvinit_all.deb";
    hash = "sha256-p+t4W8mR+CtmSXZqxpP1U55iHhKz7sXcL3Pu+0peNrU=";
  };

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cd ./usr/lib/unifi
    cp -ar dl lib webapps $out

    runHook postInstall
  '';

  postInstall =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      ''
        patchelf --add-needed "${systemd}/lib/libsystemd.so.0" "$out/lib/native/Linux/x86_64/libubnt_sdnotify_jni.so"
      ''
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      ''
        patchelf --add-needed "${systemd}/lib/libsystemd.so.0" "$out/lib/native/Linux/aarch64/libubnt_sdnotify_jni.so"
      ''
    else
      null;

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
