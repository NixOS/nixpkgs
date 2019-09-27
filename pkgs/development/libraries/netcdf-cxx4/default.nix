{ lib, stdenv, fetchurl, netcdf, hdf5, curl }:
stdenv.mkDerivation rec {
  pname = "netcdf-cxx4";
  version = "4.3.1";

  src = fetchurl {
    url = "https://github.com/Unidata/netcdf-cxx4/archive/v${version}.tar.gz";
    sha256 = "1p4fjxxbrc0ra8kbs13d33p5zaqa4a6j1wavamr2f73cq0p3vzp3";
  };

  buildInputs = [ netcdf hdf5 curl ];
  doCheck = true;

  meta = {
    description = "C++ API to manipulate netcdf files";
    homepage = "https://www.unidata.ucar.edu/software/netcdf/";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
  };
}
