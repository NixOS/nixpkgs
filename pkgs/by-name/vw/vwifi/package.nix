{
  lib,
  stdenv,
  fetchFromGitHub,
  libnl,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vwifi";
  version = "6.3-unstable-2025-02-04";
  src = fetchFromGitHub {
    owner = "Raizo62";
    repo = "vwifi";
    rev = "18c320b1b92bea241ad801d05e0f2b4748478fd9";
    hash = "sha256-rlwBO5/xyr8KjvacxYt7dBrV1noXhwBJaElGhmM/eWU=";
  };

  patches = [ ./makefile.patch ];

  buildInputs = [
    libnl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    checksRan=0
    for bin in $out/bin/vwifi-*; do
      echo -n "$(basename -- "$bin"): "
      $bin --version 2>&1 | grep -F "${lib.versions.majorMinor finalAttrs.version}"
      checksRan=$((checksRan+1))
    done
    [ $checksRan -gt 0 ] || exit 1
  '';

  meta = {
    description = "Simulate Wi-Fi (802.11) between Linux Virtual Machines";
    homepage = "https://github.com/Raizo62/vwifi";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asappia ];
  };
})
