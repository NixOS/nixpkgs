{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lalezar-fonts";
  version = "unstable-2017-02-28";

  src = fetchFromGitHub {
    owner = "BornaIz";
    repo = "Lalezar";
    rev = "238701c4241f207e92515f845a199be9131c1109";
    sha256 = "1j3zg9qw4ahw52i0i2c69gv5gjc1f4zsdla58kd9visk03qgk77p";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/lalezar-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/lalezar-fonts
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/BornaIz/Lalezar;
    description = "A multi-script display typeface for popular culture";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
