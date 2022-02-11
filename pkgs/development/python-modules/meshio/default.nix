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
  version = "5.2.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "209885ac31b00155e43c27859d1aff0ba7f97f319ee7bed453a8b9e1677a4e52";
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
