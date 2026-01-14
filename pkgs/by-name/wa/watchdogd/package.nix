{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  libite,
  libuev,
  libconfuse,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "watchdogd";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "watchdogd";
    rev = version;
    hash = "sha256-Q3j16hxDwusZdmIjHm/CVi7VrwRziPGERAvJ3F/Bvdg=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    libite
    libuev
    libconfuse
  ];

  passthru.tests = { inherit (nixosTests) watchdogd; };

  meta = {
    description = "Advanced system & process supervisor for Linux";
    homepage = "https://troglobit.com/watchdogd.html";
    changelog = "https://github.com/troglobit/watchdogd/releases/tag/${version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vifino ];
  };
}
