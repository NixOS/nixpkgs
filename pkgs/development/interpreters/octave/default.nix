{stdenv, fetchurl, g77, readline, ncurses, perl, flex}:

assert readline != null && ncurses != null && flex != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octave-2.9.6";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/octave-2.9.6.tar.bz2;
    md5 = "10f07dbc0951a7318502a9f1e51e6388";
  };
  buildInputs = [g77 readline ncurses perl flex];
  configureFlags = "--enable-readline --enable-dl --disable-static --enable-shared";
}
