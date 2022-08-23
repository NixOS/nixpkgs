{ lib
, buildPythonPackage
, fetchPypi
, numpy
, netcdf4
, h5py
, exdown
, pytestCheckHook
, rich
}:

buildPythonPackage rec {
  pname = "meshio";
  version = "5.3.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4kBpLX/yecErE8bl17QDYpqGrStE6SMJWLPwDB7DafA=";
  };

  propagatedBuildInputs = [
    numpy
    netcdf4
    h5py
    rich
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
