{ lib
, buildPythonPackage
, fetchPypi
, numpy
, netcdf4
, h5py
, exdown
, pytestCheckHook
, rich
, setuptools
}:

buildPythonPackage rec {
  pname = "meshio";
  version = "5.3.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4kBpLX/yecErE8bl17QDYpqGrStE6SMJWLPwDB7DafA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    netcdf4
    h5py
    rich
  ];

  nativeCheckInputs = [
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
