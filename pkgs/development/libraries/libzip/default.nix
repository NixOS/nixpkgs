{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "libzip-0.11.2";
  
  src = fetchurl {
    url = "http://www.nih.at/libzip/${name}.tar.gz";
    sha256 = "1mcqrz37vjrfr4gnss37z1m7xih9x9miq3mms78zf7wn7as1znw3";
  };
  
  propagatedBuildInputs = [ zlib ];

  # At least mysqlWorkbench cannot find zipconf.h; I think also openoffice
  # had this same problem.  This links it somewhere that mysqlworkbench looks.
  postInstall = ''
    ( cd $out/include ; ln -s ../lib/libzip/include/zipconf.h zipconf.h )
  '';

  meta = {
    homepage = http://www.nih.at/libzip;
    description = "A C library for reading, creating and modifying zip archives";
  };
}
