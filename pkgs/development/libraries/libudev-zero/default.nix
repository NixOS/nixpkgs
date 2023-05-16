{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libudev-zero";
<<<<<<< HEAD
  version = "1.0.3";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "illiliti";
    repo = "libudev-zero";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-NXDof1tfr66ywYhCBDlPa+8DUfFj6YH0dvSaxHFqsXI=";
  };

  makeFlags = [ "PREFIX=$(out)" "AR=${stdenv.cc.targetPrefix}ar" ];
=======
    sha256 = "sha256-SU1pPmLLeTWZe5ybhmDplFw6O/vpEjFAKgfKDl0RS4U=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Just let the installPhase build stuff, because there's no
  # non-install target that builds everything anyway.
  dontBuild = true;

  installTargets = lib.optionals stdenv.hostPlatform.isStatic "install-static";

  meta = with lib; {
    homepage = "https://github.com/illiliti/libudev-zero";
    description = "Daemonless replacement for libudev";
    changelog = "https://github.com/illiliti/libudev-zero/releases/tag/${version}";
    maintainers = with maintainers; [ qyliss shamilton ];
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
