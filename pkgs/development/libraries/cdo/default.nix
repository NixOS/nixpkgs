{ stdenv, fetchurl, curl, hdf5, netcdf
, enable_cdi_lib ? false    # build, install and link to a CDI library [default=no]
, enable_all_static ? false # build a completely statically linked CDO binary  [default=no]
, enable_cxx ? false        # Use CXX as default compiler [default=no]
}:

stdenv.mkDerivation rec {
  version = "1.7.2";
  name = "cdo-${version}";
  
  # Dependencies 
  buildInputs = [ curl netcdf hdf5 ];

  src = fetchurl {
    url = "https://code.zmaw.de/attachments/download/12760/${name}.tar.gz";
    sha256 = "4c43eba7a95f77457bfe0d30fb82382b3b5f2b0cf90aca6f0f0a008f6cc7e697";
  };

 # Configure phase 
 configureFlags = [
   "--with-netcdf=${netcdf}" "--with-hdf5=${hdf5}"]
   ++ stdenv.lib.optional (enable_cdi_lib) "--enable-cdi-lib"
   ++ stdenv.lib.optional (enable_all_static) "--enable-all-static"
   ++ stdenv.lib.optional (enable_cxx) "--enable-cxx";

  meta = {
    description = "Collection of command line Operators to manipulate and analyse Climate and NWP model Data";
    longDescription = ''
      Supported data formats are GRIB 1/2, netCDF 3/4, SERVICE, EXTRA and IEG.
      There are more than 600 operators available.
    '';
    homepage = https://code.zmaw.de/projects/cdo/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.ltavard ];
    platforms = stdenv.lib.platforms.linux;
    };
}
