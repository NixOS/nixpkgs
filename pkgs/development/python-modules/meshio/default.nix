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
  version = "4.4.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kv832s2vyff30zz8yqypw5jifwdanvh5x56d2bzkvy94h4jlddy";
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
