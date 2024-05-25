{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, setuptools-git
, numpy
, pillow
}:

buildPythonPackage rec {
  version = "0.1.5";
  pname = "daltonlens";
  disabled = pythonOlder "3.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T7fXlRdFtcVw5WURPqZhCmulUi1ZnCfCXgcLtTHeNas=";
  };

  buildInputs = [
    setuptools
    setuptools-git
  ];

  propagatedBuildInputs = [
    numpy
    pillow
  ];

  pythonImportsCheck = [
    "daltonlens"
  ];

  meta = with lib; {
    description = "R&D companion package for the desktop application DaltonLens";
    homepage = "https://github.com/DaltonLens/DaltonLens-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
