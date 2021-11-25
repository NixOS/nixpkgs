{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "libdivsufsort";
  version = "2.0.1";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdivsufsort/libdivsufsort-${version}.tar.bz2";
    sha256 = "1g0q40vb2k689bpasa914yi8sjsmih04017mw20zaqqpxa32rh2m";
  };

  meta = {
    homepage = "https://github.com/y-256/libdivsufsort";
    license = lib.licenses.mit;
    description = "Library to construct the suffix array and the BW transformed string";
    platforms = lib.platforms.unix;
  };
}
