{ fetchurl
, lib
, stdenv
, cmake
, netcdf
, openjpeg
, libpng
, gfortran
, perl
, enablePython ? false
, pythonPackages
, enablePosixThreads ? false
, enableOpenMPThreads ? false
}:

stdenv.mkDerivation rec {
  pname = "eccodes";
  version = "2.24.2";

  src = fetchurl {
    url = "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-${version}-Source.tar.gz";
    sha256 = "sha256-xgrQ/YnhGRis4NhMAUifISIrEdbK0/90lYVqCt1hBAM=";
  };

  postPatch = ''
    substituteInPlace cmake/FindOpenJPEG.cmake --replace openjpeg-2.1 ${openjpeg.incDir}
  '';

  nativeBuildInputs = [ cmake gfortran perl ];

  buildInputs = [
    netcdf
    openjpeg
    libpng
  ];

  propagatedBuildInputs = lib.optionals enablePython [
    pythonPackages.python
    pythonPackages.numpy
  ];

  cmakeFlags = [
    "-DENABLE_PYTHON=${if enablePython then "ON" else "OFF"}"
    "-DENABLE_PNG=ON"
    "-DENABLE_ECCODES_THREADS=${if enablePosixThreads then "ON" else "OFF"}"
    "-DENABLE_ECCODES_OMP_THREADS=${if enableOpenMPThreads then "ON" else "OFF"}"
  ];

  doCheck = true;

  # Only do tests that don't require downloading 120MB of testdata
  checkPhase = lib.optionalString (stdenv.isDarwin) ''
    substituteInPlace "tests/include.sh" --replace "set -ea" "set -ea; export DYLD_LIBRARY_PATH=$(pwd)/lib"
  '' + ''
    ctest -R "eccodes_t_(definitions|calendar|unit_tests|md5|uerra|grib_2nd_order_numValues|julian)" -VV
  '';

  meta = with lib; {
    homepage = "https://confluence.ecmwf.int/display/ECC/";
    license = licenses.asl20;
    maintainers = with maintainers; [ knedlsepp ];
    platforms = platforms.unix;
    description = "ECMWF library for reading and writing GRIB, BUFR and GTS abbreviated header";
  };
}
