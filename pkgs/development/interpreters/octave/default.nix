{stdenv, fetchurl, g77, readline, ncurses}:

assert readline != null && ncurses != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octave-2.1.57";
  src = fetchurl {
    url = ftp://ftp.octave.org/pub/octave/octave-2.1.57.tar.bz2;
    md5 = "b781f5d0cd750cb9bb3ef23523f5f339";
  };
  buildInputs = [g77 readline ncurses];
  configureFlags = "--enable-readline";
}
