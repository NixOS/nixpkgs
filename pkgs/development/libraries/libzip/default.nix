{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "libzip-0.10";
  
  src = fetchurl {
    url = "http://www.nih.at/libzip/${name}.tar.gz";
    sha256 = "1lnpxcl4z084bvx3jd0pqgr350ljnizpnlwh5vbzjp0iw9jakbxp";
  };
  
  propagatedBuildInputs = [ zlib ];

  meta = {
    homepage = http://www.nih.at/libzip;
    description = "A C library for reading, creating and modifying zip archives";
  };
}
