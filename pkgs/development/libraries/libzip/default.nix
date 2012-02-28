{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "libzip-0.10";
  
  src = fetchurl {
    url = "http://www.nih.at/libzip/${name}.tar.gz";
    sha256 = "1lnpxcl4z084bvx3jd0pqgr350ljnizpnlwh5vbzjp0iw9jakbxp";
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
