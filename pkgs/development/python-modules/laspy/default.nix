{ lib
, buildPythonPackage
, fetchPypi
, numpy
, laszip
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "laspy";
  version = "2.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uqPJxswVVjbxYRSREfnPwkPb0U9synKclLNWsxxmjy4=";
  };

  propagatedBuildInputs = [
    numpy
    laszip
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "laspy"
    "laszip"
  ];

  meta = with lib; {
    description = "Interface for reading/modifying/creating .LAS LIDAR files";
    homepage = "https://github.com/laspy/laspy";
    changelog = "https://github.com/laspy/laspy/blob/2.4.1/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
