{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "szip";
  version = "2.1.1";
  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/lib-external/szip/${version}/src/szip-${version}.tar.gz";
    sha256 = "04nlhkzzf1gihvrfbzc6rq4kc13p92ly39dzrb4y4jrd9y5rbvi1";
  };

  meta = {
    description = "Compression library that can be used with the hdf5 library";
    homepage = "https://www.hdfgroup.org/doc_resource/SZIP/";
    license = lib.licenses.unfree;
  };
}
