{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.20";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "sha256-XR9yofUav2qc0j6qgS+xe4YQlwWQlfSMdoxINcWqJZg=";
  };

  meta = with lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = "http://matio.sourceforge.net/";
  };
}
