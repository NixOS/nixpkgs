{stdenv, fetchurl, g77, readline, ncurses, perl}:

assert readline != null && ncurses != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octave-2.1.61";
  src = fetchurl {
    url = ftp://ftp.octave.org/pub/octave/bleeding-edge/octave-2.1.60.tar.bz2;
    md5 = "66416e4c219dd1f2a83ec45c6958396b";
  };
  buildInputs = [g77 readline ncurses perl];
  configureFlags = "--enable-readline --enable-dl --disable-static --enable-shared";
}
