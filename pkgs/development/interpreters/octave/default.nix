{stdenv, fetchurl, g77, readline, ncurses}:

assert readline != null && ncurses != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octave-2.1.60";
  src = fetchurl {
    url = ftp://ftp.octave.org/pub/octave/bleeding-edge/octave-2.1.60.tar.bz2;
    md5 = "d332151ada009a14e4e4e37521a4ccfa";
  };
  buildInputs = [g77 readline ncurses];
  configureFlags = "--enable-readline --enable-dl --disable-static --enable-shared";
}
