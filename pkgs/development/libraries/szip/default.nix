{ stdenv, fetchurl }:
    
stdenv.mkDerivation rec {
  name = "szip-${version}";
  version = "2.1.1";
  src = fetchurl {
    url = "ftp://ftp.hdfgroup.org/lib-external/szip/${version}/src/szip-${version}.tar.gz";
    sha256 = "1a8415a7xifagb22aq9dmy7b2s5l0y6diany3b4qigylw6adlzc9";
  };

  meta = {
    description = "Compression library that can be used with the hdf5 library";
    homepage = http://www.hdfgroup.org/doc_resource/SZIP/;
    license = stdenv.lib.licenses.unfree;
  };
}
