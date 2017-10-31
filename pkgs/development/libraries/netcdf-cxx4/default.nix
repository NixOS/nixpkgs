{ stdenv, fetchurl, netcdf, hdf5, curl }:
stdenv.mkDerivation rec {
  name = "netcdf-cxx4-${version}";
  version = "4.2.1";

  src = fetchurl {
    url = "https://github.com/Unidata/netcdf-cxx4/archive/v${version}.tar.gz";
    sha256 = "1g0fsmz59dnjib4a7r899lm99j3z6yxsw10c0wlihclzr6znmmds";
  };

  buildInputs = [ netcdf hdf5 curl ];
  doCheck = true;

  meta = {
    description = "C++ API to manipulate netcdf files";
    homepage = http://www.unidata.ucar.edu/software/netcdf/;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
  };
}
