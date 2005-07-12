{stdenv, fetchurl, x11}:

stdenv.mkDerivation {
  name = "SDL-1.2.8";
  src = fetchurl {
    url = http://www.libsdl.org/release/SDL-1.2.8.tar.gz;
    md5 = "37aaf9f069f9c2c18856022f35de9f8c";
  };
  buildInputs = [x11];
  patches = [./no-cxx.patch];
}
