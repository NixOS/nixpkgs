{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libudev-zero";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "illiliti";
    repo = "libudev-zero";
    rev = version;
    sha256 = "sha256-SU1pPmLLeTWZe5ybhmDplFw6O/vpEjFAKgfKDl0RS4U=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

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
