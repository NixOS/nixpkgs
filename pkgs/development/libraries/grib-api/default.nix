{ fetchurl, fetchpatch, stdenv,
  cmake, netcdf, gfortran, libpng, openjpeg,
  enablePython ? false, pythonPackages }:

stdenv.mkDerivation rec{
  pname = "grib-api";
  version = "1.28.0";

  src = fetchurl {
    url = "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-${version}-Source.tar.gz";
    sha256 = "0qbj12ap7yy2rl1pq629chnss2jl73wxdj1lwzv0xp87r6z5qdfl";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/grib-api/raw/debian/1.28.0-2/debian/patches/openjpeg2.patch";
      sha256 = "05faxh51vlidiazxq1ssd3k4cjivk1adyn30k94mxqa1xnb2r2pc";
    })
  ];

  preConfigure = ''
    # Fix "no member named 'inmem_' in 'jas_image_t'"
    substituteInPlace "src/grib_jasper_encoding.c" --replace "image.inmem_    = 1;" ""
  '';

  buildInputs = [ cmake
                  netcdf
                  gfortran
                  libpng
                  openjpeg
                ] ++ stdenv.lib.optionals enablePython [
                  pythonPackages.python
                ];

  propagatedBuildInputs = stdenv.lib.optionals enablePython [
                  pythonPackages.numpy
                ];

  cmakeFlags = [ "-DENABLE_PYTHON=${if enablePython then "ON" else "OFF"}"
                 "-DENABLE_PNG=ON"
                 "-DENABLE_FORTRAN=ON"
                 "-DOPENJPEG_INCLUDE_DIR=${openjpeg.dev}/include/${openjpeg.incDir}"
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
    description = "ECMWF Library for the GRIB file format -- DEPRECATED";
    longDescription = ''
      The ECMWF GRIB API is an application program interface accessible from C,
      FORTRAN and Python programs developed for encoding and decoding WMO FM-92
      GRIB edition 1 and edition 2 messages.

      Please note: GRIB-API support is being discontinued at the end of 2018.
      After which there will be no further releases. Please upgrade to ecCodes
    '';
    maintainers = with maintainers; [ knedlsepp ];
  };
}
