{ stdenv, fetchurl, python, buildPythonPackage
, numpy, hdf5, cython
, mpiSupport ? false, mpi4py ? null, mpi ? null }:

assert mpiSupport == hdf5.mpiSupport;
assert mpiSupport -> mpi != null
  && mpi4py != null
  && mpi == mpi4py.mpi
  && mpi == hdf5.mpi
  ;

with stdenv.lib;

buildPythonPackage rec {
  name = "h5py-2.3.1";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/h/h5py/${name}.tar.gz";
    md5 = "8f32f96d653e904d20f9f910c6d9dd91";
  };

  setupPyBuildFlags = [ "--hdf5=${hdf5}" ]
    ++ optional mpiSupport "--mpi"
    ;
  setupPyInstallFlags = setupPyBuildFlags;

  preBuild = if mpiSupport then "export CC=${mpi}/bin/mpicc" else "";

  buildInputs = [ hdf5 cython ]
    ++ optional mpiSupport mpi
    ;
  propagatedBuildInputs = [ numpy ]
    ++ optional mpiSupport mpi4py
    ;

  meta = {
    description =
      "Pythonic interface to the HDF5 binary data format";
    homepage = "http://www.h5py.org/";
    license = stdenv.lib.licenses.bsd2;
  };
}
