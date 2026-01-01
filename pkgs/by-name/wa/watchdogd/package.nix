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
<<<<<<< HEAD
  version = "4.1";
=======
  version = "4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "watchdogd";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Q3j16hxDwusZdmIjHm/CVi7VrwRziPGERAvJ3F/Bvdg=";
=======
    hash = "sha256-JNJj0CJGJXuIRpob2RXYqDRrU4Cn20PRxOjQ6TFsVYQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
