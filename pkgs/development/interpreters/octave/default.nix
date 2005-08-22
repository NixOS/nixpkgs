{stdenv, fetchurl, g77, readline, ncurses, perl, flex}:

assert readline != null && ncurses != null && flex != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octave-2.9.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/octave-2.9.0.tar.bz2;
    md5 = "687a09033bc68f09810e947010bc8f29";
  };
  buildInputs = [g77 readline ncurses perl flex];
  configureFlags = "--enable-readline --enable-dl --disable-static --enable-shared";
}
