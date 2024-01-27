{ lib
, buildPythonPackage
, fetchPypi
, numpy
, laszip
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "laspy";
  version = "2.5.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-StaYkUNY6loJbaUuabzszTINnd+zZ0gKXCteCG24Erc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    laszip
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "laspy"
    "laszip"
  ];

  meta = with lib; {
    description = "Interface for reading/modifying/creating .LAS LIDAR files";
    homepage = "https://github.com/laspy/laspy";
    changelog = "https://github.com/laspy/laspy/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
