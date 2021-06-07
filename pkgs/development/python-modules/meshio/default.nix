{ lib
, buildPythonPackage
, fetchPypi
, numpy
, netcdf4
, h5py
, exdown
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "meshio";
  version = "4.3.10";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i34bk8bbc0dnizrlgj0yxnbzyvndkmnl6ryymxgcl9rv1abkfki";
  };

  propagatedBuildInputs = [
    numpy
    netcdf4
    h5py
  ];

  checkInputs = [
    exdown
    pytestCheckHook
  ];

  pythonImportsCheck = ["meshio"];

  meta = with lib; {
    homepage = "https://github.com/nschloe/meshio";
    description = "I/O for mesh files.";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
