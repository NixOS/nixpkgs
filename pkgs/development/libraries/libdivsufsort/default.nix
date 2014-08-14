{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdivsufsort-2.0.1";
  
  src = fetchurl {
    url = http://libdivsufsort.googlecode.com/files/libdivsufsort-2.0.1.tar.bz2;
    sha256 = "1g0q40vb2k689bpasa914yi8sjsmih04017mw20zaqqpxa32rh2m";
  };

  meta = {
    homepage = http://code.google.com/p/libdivsufsort/;
    license = stdenv.lib.licenses.mit;
    description = "Library to construct the suffix array and the BW transformed string";
  };
}
