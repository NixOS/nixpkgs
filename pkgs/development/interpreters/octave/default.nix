{stdenv, fetchurl, g77, readline, ncurses, perl}:

assert readline != null && ncurses != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octave-2.1.64";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/octave-2.1.64.tar.bz2;
    md5 = "01ec8b13bd850123b190129be93adc1f";
  };
  buildInputs = [g77 readline ncurses perl];
  configureFlags = "--enable-readline --enable-dl --disable-static --enable-shared";
}
