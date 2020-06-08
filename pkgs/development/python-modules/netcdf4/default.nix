{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy
, numpy, zlib, netcdf, hdf5, curl, libjpeg, cython, cftime
,mpi4py ? null, openssh ? null}:
assert (mpi4py != null) -> 
  openssh != null
  && hdf5.mpi == mpi4py.mpi 
  && netcdf.mpi == mpi4py.mpi;

let 
  mpiSupport = (mpi4py != null);
  mpi= if mpiSupport then mpi4py.mpi else null;
in
buildPythonPackage rec {
  pname = "netCDF4";
  version = "1.5.3";

  disabled = isPyPy;
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "2a3ca855848f4bbf07fac366da77a681fcead18c0a8813d91d46302f562dc3be";
  };

  checkInputs = [ netcdf numpy ] ++(if mpiSupport then [ mpi4py openssh ] else []);

  nativeBuildInputs = [
    cython 
  ];

  buildInputs = [
    mpi 
  ];

  propagatedBuildInputs = [
    cftime
    numpy
    zlib
    netcdf
    hdf5
    curl
    libjpeg
  ] ++ (if mpiSupport then [mpi4py mpi openssh] else []);

  #patches=[./skipDapTest.patch];

  makeFlags = lib.optionals mpiSupport [ "CC=mpicc" "CXX=mpicxx" ];

  checkPhase= ''
    cd test
    rm tst_dap.py # does not fail in the nix-shell  
    python -m unittest tst_*.py
  '';


  # Variables used to configure the build process
  USE_NCCONFIG="0";
  HDF5_DIR= lib.getDev hdf5;
  NETCDF4_DIR="${netcdf}";
  CURL_DIR="${curl.dev}";
  JPEG_DIR="${libjpeg.dev}";
  
  passthru = {
    mpiSupport = mpiSupport;
    inherit mpi;
  }; 

  meta = with stdenv.lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = "https://pypi.python.org/pypi/netCDF4";
    license = licenses.free;  # Mix of license (all MIT* like)
  };
}
