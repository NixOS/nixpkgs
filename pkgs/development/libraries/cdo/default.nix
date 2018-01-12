{ stdenv, fetchurl, curl, hdf5, netcdf
, enable_cdi_lib ? false    # build, install and link to a CDI library [default=no]
, enable_all_static ? false # build a completely statically linked CDO binary  [default=no]
, enable_cxx ? false        # Use CXX as default compiler [default=no]
}:

stdenv.mkDerivation rec {
  version = "1.9.0";
  name = "cdo-${version}";

  # Dependencies
  buildInputs = [ curl netcdf hdf5 ];

  src = fetchurl {
    url = "https://code.mpimet.mpg.de/attachments/download/15187/${name}.tar.gz";
    sha256 = "024hsr6qfg2dicwvm0vvkg3fr998bchf0qgwpj2v0jmz7a67ydnz";
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
    homepage = https://code.mpimet.mpg.de/projects/cdo/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.ltavard ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
