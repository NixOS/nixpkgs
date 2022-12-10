{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libudev-zero";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "illiliti";
    repo = "libudev-zero";
    rev = version;
    sha256 = "1dg6zqy8w3gxca8clz6hhv4jyvz8jdwvpmn9y289nrms1zx1jcs5";
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
