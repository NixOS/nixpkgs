{ stdenv, fetchurl, netcdf, netcdfcxx4, gsl, udunits, antlr, which, curl, flex }:

stdenv.mkDerivation rec {
  version = "4.8.1";
  pname = "nco";

  buildInputs = [ netcdf netcdfcxx4 gsl udunits antlr which curl flex ];

  src = fetchurl {
    url = "https://github.com/nco/nco/archive/${version}.tar.gz";
    sha256 = "0s1ww78p4cb2d9qkr4zs439x4xk3ndq6lv8ps677jrn28vnkzbnx";
  };

  meta = {
    description = "NetCDF Operator toolkit";
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    homepage = http://nco.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux;
  };
}
