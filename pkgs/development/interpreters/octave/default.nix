{stdenv, fetchurl, g77, readline, ncurses, perl}:

assert readline != null && ncurses != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octave-2.9.0";
  src = fetchurl {
    url = ftp://ftp.octave.org/pub/octave/bleeding-edge/octave-2.9.0.tar.bz2;
    md5 = "f0fbf6995241b957f078962f7c1148df";
  };
  buildInputs = [g77 readline ncurses perl];
  configureFlags = "--enable-readline --enable-dl --disable-static --enable-shared";
}
