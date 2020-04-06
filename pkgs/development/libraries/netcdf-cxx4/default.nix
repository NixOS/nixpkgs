{ stdenv, fetchurl, netcdf, hdf5, curl }:
stdenv.mkDerivation rec {
  pname = "netcdf-cxx4";
  version = "4.3.0";

  src = fetchurl {
    url = "https://github.com/Unidata/netcdf-cxx4/archive/v${version}.tar.gz";
    sha256 = "13zi8cbk18gggx1c12a580wdsbl714lw68a1wg7c86x0sybirni5";
  };

  buildInputs = [ netcdf hdf5 curl ];
  doCheck = true;

  meta = {
    description = "C++ API to manipulate netcdf files";
    homepage = https://www.unidata.ucar.edu/software/netcdf/;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
  };
}
