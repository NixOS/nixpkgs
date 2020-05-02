{ lib, buildPythonPackage, fetchPypi, setuptools, numpy, netcdf4, h5py, importlib-metadata }:

buildPythonPackage rec {
  pname = "meshio";
  version = "4.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vjq8f0cqwy3qnh8j7zj8cqy5dmyzln8gncqji42ya8z31mhagib";
  };

  propagatedBuildInputs = [ importlib-metadata numpy netcdf4 h5py ];

  patches = [
    ./add_empty_setup.patch
  ];

  meta = with lib; {
    description = "I/O for mesh files";
    homepage = "https://github.com/nschloe/meshio";
    license = licenses.mit;
    maintainers = [ maintainers.wulfsta ];
  };
}
