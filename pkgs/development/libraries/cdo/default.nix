{ lib, stdenv, fetchurl, curl, hdf5, netcdf
, # build, install and link to a CDI library [default=no]
  enable_cdi_lib ? false
, # build a completely statically linked CDO binary
  enable_all_static ? stdenv.hostPlatform.isStatic
, # Use CXX as default compiler [default=no]
  enable_cxx ? false
}:

stdenv.mkDerivation rec {
  pname = "cdo";
  version = "1.9.7.1";

  # Dependencies
  buildInputs = [ curl netcdf hdf5 ];

  src = fetchurl {
    url = "https://code.mpimet.mpg.de/attachments/download/20124/${pname}-${version}.tar.gz";
    sha256 = "0b4n8dwxfsdbz4jflsx0b75hwapdf1rp14p48dfr7ksv0qp9aw9p";
  };

 # Configure phase
 configureFlags = [
   "--with-netcdf=${netcdf}" "--with-hdf5=${hdf5}"]
   ++ lib.optional (enable_cdi_lib) "--enable-cdi-lib"
   ++ lib.optional (enable_all_static) "--enable-all-static"
   ++ lib.optional (enable_cxx) "--enable-cxx";

  meta = with lib; {
    description = "Collection of command line Operators to manipulate and analyse Climate and NWP model Data";
    longDescription = ''
      Supported data formats are GRIB 1/2, netCDF 3/4, SERVICE, EXTRA and IEG.
      There are more than 600 operators available.
    '';
    homepage = "https://code.mpimet.mpg.de/projects/cdo/";
    license = licenses.gpl2;
    maintainers = [ maintainers.ltavard ];
    platforms = with platforms; linux ++ darwin;
  };
}
