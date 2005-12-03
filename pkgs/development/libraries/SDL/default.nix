{stdenv, fetchurl, x11}:

stdenv.mkDerivation {
  name = "SDL-1.2.9";
  src = fetchurl {
    url = http://www.libsdl.org/release/SDL-1.2.9.tar.gz;
    md5 = "80919ef556425ff82a8555ff40a579a0";
  };
  buildInputs = [x11];
  patches = [./no-cxx.patch];
  NIX_CFLAGS_COMPILE = "-DBITS_PER_LONG=32"; /* !!! hack around kernel header bug */
}
