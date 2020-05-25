{ stdenv, fetchzip, netcdf, netcdfcxx4, gsl, udunits, antlr, which, curl, flex }:

stdenv.mkDerivation rec {
  version = "4.9.2";
  pname = "nco";

  nativeBuildInputs = [ flex which ];
  buildInputs = [ netcdf netcdfcxx4 gsl udunits antlr curl ];

  src = fetchzip {
    url = "https://github.com/nco/nco/archive/${version}.tar.gz";
    sha256 = "0nip9dmdx3d5nc30bz1d2w9his1dph136l53r160aa3bmb29xwqn";
  };

  meta = {
    description = "NetCDF Operator toolkit";
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    homepage = "http://nco.sourceforge.net/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux;
  };
}
