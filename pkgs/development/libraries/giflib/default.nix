{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "giflib-4.2.3";
  src = fetchurl {
    url = mirror://sourceforge/giflib/giflib-4.2.3.tar.bz2;
    sha256 = "0rmp7ipzk42r841bggd7bfqk4p8qsssbp4wcck4qnz7p4rkxbj0a";
  };
}

