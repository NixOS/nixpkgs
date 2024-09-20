{ lib, stdenv, fetchurl, curl, hdf5, netcdf, eccodes, python3
, # build, install and link to a CDI library [default=no]
  enable_cdi_lib ? false
, # build a completely statically linked CDO binary
  enable_all_static ? stdenv.hostPlatform.isStatic
, # Use CXX as default compiler [default=no]
  enable_cxx ? false
}:

stdenv.mkDerivation rec {
  pname = "cdo";
  version = "2.4.2";

  # Dependencies
  buildInputs = [ curl netcdf hdf5 python3 ];

  src = fetchurl {
    url = "https://code.mpimet.mpg.de/attachments/download/29481/${pname}-${version}.tar.gz";
    sha256 = "sha256-TfH+K4+S9Uwn6585nt+rQNkyIAWmcyyhUk71wWJ6xOc=";
  };

 configureFlags = [
    "--with-netcdf=${netcdf}"
    "--with-hdf5=${hdf5}"
    "--with-eccodes=${eccodes}"
  ]
   ++ lib.optional enable_cdi_lib "--enable-cdi-lib"
   ++ lib.optional enable_all_static "--enable-all-static"
   ++ lib.optional enable_cxx "--enable-cxx";

  # address error: 'TARGET_OS_MACCATALYST' is not defined,
  # evaluates to 0 [-Werror,-Wundef-prefix=TARGET_OS_]
  # we don't want to appear to be a catalyst build;
  # we are a TARGET_OS_MAC
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-DTARGET_OS_MACCATALYST=0";

  meta = with lib; {
    description = "Collection of command line Operators to manipulate and analyse Climate and NWP model Data";
    mainProgram = "cdo";
    longDescription = ''
      Supported data formats are GRIB 1/2, netCDF 3/4, SERVICE, EXTRA and IEG.
      There are more than 600 operators available.
    '';
    homepage = "https://code.mpimet.mpg.de/projects/cdo/";
    license = licenses.bsd3;
    maintainers = [ maintainers.ltavard ];
    platforms = with platforms; linux ++ darwin;
  };
}
