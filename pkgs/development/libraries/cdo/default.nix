{ stdenv, fetchurl, curl
, enable_data ? true        # DATA support [default=yes]
, enable_grib ? true        # GRIB support [default=yes]
, enable_cgribex ? true     # Use the CGRIBEX library [default=yes]
, enable_service ? true     # Use the service library [default=yes]
, enable_extra ? true       # Use the extra library [default=yes]
, enable_ieg ? true         # Use the ieg library [default=yes]
, enable_cdi_lib ? false    # build, install and link to a CDI library [default=no]
, enable_all_static ? false # build a completely statically linked CDO binary  [default=no]
, enable_cxx ? false        # Use CXX as default compiler [default=no]
, with_gnu_ld ? false       # assume the C compiler uses GNU ld [default=no]
, with_hdf5 ? true          #<yes|no|directory> (default=no) location of HDF5 library
, hdf5 ? null
, with_netcdf ? true        #<yes|no|directory> (default=no)location of NetCDF library
, netcdf ? null 
}:

assert with_netcdf   -> ( netcdf != null );
assert with_hdf5     -> ( hdf5 != null );

stdenv.mkDerivation rec {
  version = "1.7.2";
  name = "cdo-${version}";
  
  # Dependencies 
  buildInputs = [ curl ]
    ++ stdenv.lib.optional with_netcdf [ netcdf ]
    ++ stdenv.lib.optional with_hdf5 [ hdf5 ];

  src = fetchurl {
    url = "https://code.zmaw.de/attachments/download/12760/${name}.tar.gz";
    sha256 = "4c43eba7a95f77457bfe0d30fb82382b3b5f2b0cf90aca6f0f0a008f6cc7e697";
  };

  # Check phase
  doCheck = true;
 
  # Configure phase 
  configureFlags = ''
    ${if enable_data then       "--enable-data" else ""}
    ${if enable_grib then       "--enable-grib" else ""}
    ${if enable_cgribex then    "--enable-cgribex" else ""}
    ${if enable_service then    "--enable-service" else ""}
    ${if enable_extra then      "--enable-extra" else ""}
    ${if enable_ieg then        "--enable-ieg" else ""}
    ${if enable_cdi_lib then    "--enable-cdi-lib" else ""}
    ${if enable_all_static then "--enable-all-static" else ""}
    ${if enable_cxx then        "--enable-cxx" else ""}
    ${if with_gnu_ld then       "--with-gnu-ld" else ""}
    ${if with_hdf5 then         "--with-hdf5=${hdf5}" else "--with-hdf5=no"}
    ${if with_netcdf then       "--with-netcdf=${netcdf}" else "--with-netcdf=no"}
    '';

  meta = {
    description = "collection of command line Operators to manipulate and analyse Climate and NWP model Data";
    longDescription = '' Supported data formats are GRIB 1/2, netCDF 3/4, SERVICE, EXTRA and IEG. 
    There are more than 600 operators available. '';
    homepage = https://code.zmaw.de/projects/cdo/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.ltavard ];
    platforms = stdenv.lib.platforms.linux;
    };
}
