{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.19";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "0vr8c1mz1k6mz0sgh6n3scl5c3a71iqmy5fnydrgq504icj4vym4";
  };

  meta = with lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = "http://matio.sourceforge.net/";
  };
}
