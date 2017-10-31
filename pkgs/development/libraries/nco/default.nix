{ stdenv, fetchurl, netcdf, netcdfcxx4, gsl, udunits, antlr, which, curl }:

stdenv.mkDerivation rec {
  version = "4.5.5";
  name = "nco-${version}";

  buildInputs = [ netcdf netcdfcxx4 gsl udunits antlr which curl ];

  src = fetchurl {
    url = "https://github.com/nco/nco/archive/${version}.tar.gz";
    sha256 = "bc6f5b976fdfbdec51f2ebefa158fa54672442c2fd5f042ba884f9f32c2ad666";
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
