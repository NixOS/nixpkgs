{ fetchurl, stdenv,
  cmake, netcdf, gfortran, jasper, libpng,
  enablePython ? false, pythonPackages }:

stdenv.mkDerivation rec{
  name = "grib-api-${version}";
  version = "1.19.0";

  src = fetchurl {
    url = "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-${version}-Source.tar.gz";
    sha256 = "07cj9mw5bb249lxx1m9nmfdqb8b2a8cm7s6x62cdwca3sp16dv6a";
  };

  preConfigure = ''
    # Fix "no member named 'inmem_' in 'jas_image_t'"
    substituteInPlace "src/grib_jasper_encoding.c" --replace "image.inmem_    = 1;" ""
  '';

  buildInputs = [ cmake
                  netcdf
                  gfortran
                  jasper
                  libpng
                ] ++ stdenv.lib.optionals enablePython [
                  pythonPackages.python
                ];

  propagatedBuildInputs = stdenv.lib.optionals enablePython [
                  pythonPackages.numpy
                ];

  cmakeFlags = [ "-DENABLE_PYTHON=${if enablePython then "ON" else "OFF"}"
                 "-DENABLE_PNG=ON"
                 "-DENABLE_FORTRAN=ON"
               ];

  enableParallelBuilding = true;

  doCheck = true;

  # Only do tests that don't require downloading 120MB of testdata
  # We fix the darwin checkPhase, which searches for libgrib_api.dylib
  # in /nix/store by setting DYLD_LIBRARY_PATH
  checkPhase = stdenv.lib.optionalString (stdenv.isDarwin) ''
    substituteInPlace "tests/include.sh" --replace "set -ea" "set -ea; export DYLD_LIBRARY_PATH=$(pwd)/lib"
  '' + ''
    ctest -R "t_definitions|t_calendar|t_unit_tests" -VV
  '';


  meta = with stdenv.lib; {
    homepage = https://software.ecmwf.int/wiki/display/GRIB/Home;
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin;
    description = "ECMWF Library for the GRIB file format";
    longDescription = ''
      The ECMWF GRIB API is an application program interface accessible from C,
      FORTRAN and Python programs developed for encoding and decoding WMO FM-92
      GRIB edition 1 and edition 2 messages.
    '';
    maintainers = with maintainers; [ knedlsepp ];
  };
}

