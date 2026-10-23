{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libnl,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vwifi";
  version = "7.1";
  src = fetchFromGitHub {
    owner = "Raizo62";
    repo = "vwifi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ed7MLPLdKIK9e4EQq83GwKWiOX3tNJShiFdnNgFGj7Q=";
  };

  buildInputs = [
    libnl
  ];

  nativeBuildInputs = [
    cmake
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
