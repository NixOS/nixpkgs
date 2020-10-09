{ lib, buildPythonPackage, fetchPypi, setuptools, numpy, netcdf4, h5py, importlib-metadata }:

buildPythonPackage rec {
  pname = "meshio";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1khmyfhkjq19lpcba3bzzish7fpx9z9mi2fw0wgsp7li637cfxcw";
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
