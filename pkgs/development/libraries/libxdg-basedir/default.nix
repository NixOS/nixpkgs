<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libxdg-basedir";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "devnev";
    repo = pname;
    rev = "refs/tags/libxdg-basedir-${version}";
    hash = "sha256-ewtUKDdE6k9Q9hglWwhbTU3DTxvIN41t+zf2Gch9Dkk=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "Implementation of the XDG Base Directory specification";
    homepage = "https://github.com/devnev/libxdg-basedir";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
=======
{lib, stdenv, fetchurl, fetchpatch}:

stdenv.mkDerivation rec {
  pname = "libxdg-basedir";
  version = "1.2.0";

  src = fetchurl {
    url = "https://nevill.ch/libxdg-basedir/downloads/libxdg-basedir-${version}.tar.gz";
    sha256 = "2757a949618742d80ac59ee2f0d946adc6e71576406cdf798e6ced507708cdf4";
  };

  patches = [
    # Overflow bug
    (fetchpatch {
      url = "https://github.com/devnev/libxdg-basedir/commit/14e000f696ef8b83264b0ca4407669bdb365fb23.patch";
      sha256 = "0lpy1ijir0x0hhb0fz0w5vxy1wl1cw9kkd6gva0rkp41i6vrp2wq";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/devnev/libxdg-basedir";
    description = "Implementation of the XDG Base Directory specification";
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
