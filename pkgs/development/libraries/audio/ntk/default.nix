<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, cairo, libjpeg, libXft, pkg-config, python3, waf }:
=======
{ lib, stdenv, fetchFromGitHub, cairo, libjpeg, libXft, pkg-config, python3, wafHook }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "ntk";
  version = "1.3.1001";
  src = fetchFromGitHub {
    owner = "linuxaudio";
    repo = "ntk";
    rev = "v${version}";
    sha256 = "sha256-NyEdg6e+9CI9V+TIgdpPyH1ei+Vq8pUxD3wPzWY5fEU=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config waf.hook ];
=======
  nativeBuildInputs = [ pkg-config wafHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    cairo libjpeg libXft python3
  ];

  meta = {
    description = "Fork of FLTK 1.3.0 with additional functionality";
    version = version;
    homepage = "http://non.tuxfamily.org/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ magnetophon nico202 ];
    platforms = lib.platforms.linux;
  };
}
