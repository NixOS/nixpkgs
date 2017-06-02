{ stdenv, buildPythonPackage, fetchurl, isPyPy
, numpy, zlib, netcdf, hdf5, curl, libjpeg
}:
buildPythonPackage rec {
  pname = "netCDF4";
  name = "${pname}-${version}";
  version = "1.2.8";

  disabled = isPyPy;

  src = fetchurl {
    url = "mirror://pypi/n/netCDF4/${name}.tar.gz";
    sha256 = "31eb4eae5fd3b2bd8f828721142ddcefdbf10287281bf6f636764dd7957f8450";
  };

  propagatedBuildInputs = [
    numpy
    zlib
    netcdf
    hdf5
    curl
    libjpeg
  ];

  # Variables used to configure the build process
  USE_NCCONFIG="0";
  HDF5_DIR="${hdf5}";
  NETCDF4_DIR="${netcdf}";
  CURL_DIR="${curl.dev}";
  JPEG_DIR="${libjpeg.dev}";

  meta = with stdenv.lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = https://pypi.python.org/pypi/netCDF4;
    license = licenses.free;  # Mix of license (all MIT* like)
  };
}
