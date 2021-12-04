{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libudev-zero";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "illiliti";
    repo = "libudev-zero";
    rev = version;
    sha256 = "0mln7iwyz7lxz8dx7bx7b47j6yws1dvfq35qsdcwg3wwmd4ngsz6";
  };

  patches = [
    # Fix static.
    # https://github.com/illiliti/libudev-zero/pull/48
    (fetchpatch {
      url = "https://github.com/illiliti/libudev-zero/commit/505c61819b371a1802e054fe2601e64f2dc6d79e.patch";
      sha256 = "0y06rgjv73dd7fi3a0dlabcc8ryk3yhbsyrrhnnn3v36y1wz6m0g";
    })
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  # Just let the installPhase build stuff, because there's no
  # non-install target that builds everything anyway.
  dontBuild = true;

  installTargets = lib.optionals stdenv.hostPlatform.isStatic "install-static";

  meta = with lib; {
    homepage = "https://github.com/illiliti/libudev-zero";
    description = "Daemonless replacement for libudev";
    maintainers = with maintainers; [ qyliss shamilton ];
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
