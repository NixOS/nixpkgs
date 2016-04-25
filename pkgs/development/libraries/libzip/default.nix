{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "libzip-0.11.2";

  src = fetchurl {
    url = "http://www.nih.at/libzip/${name}.tar.gz";
    sha256 = "1mcqrz37vjrfr4gnss37z1m7xih9x9miq3mms78zf7wn7as1znw3";
  };

  outputs = [ "dev" "out" ];

  # fix CVE-2015-2331 taken from Debian patch:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=12;filename=libzip-0.11.2-1.2-nmu.diff;att=1;bug=780756
  postPatch = ''
    substituteInPlace lib/zip_dirent.c --replace \
      'else if ((cd->entry=(struct zip_entry *)' \
      'else if (nentry > ((size_t)-1)/sizeof(*(cd->entry)) || (cd->entry=(struct zip_entry *)'
    cat lib/zip_dirent.c
  '';

  propagatedBuildInputs = [ zlib ];

  # At least mysqlWorkbench cannot find zipconf.h; I think also openoffice
  # had this same problem.  This links it somewhere that mysqlworkbench looks.
  postInstall = ''
    ( cd $dev/include ; ln -s ../lib/libzip/include/zipconf.h zipconf.h )
  '';

  meta = {
    homepage = http://www.nih.at/libzip;
    description = "A C library for reading, creating and modifying zip archives";
  };
}
