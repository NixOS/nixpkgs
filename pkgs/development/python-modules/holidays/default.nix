{ lib
, buildPythonPackage
, convertdate
, python-dateutil
, fetchPypi
, hijri-converter
, korean-lunar-calendar
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.14.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DnD9F0gErqHIcLFRMZ+uvNXNsNlVt4IwQ04a/Rd4SY4=";
  };

  propagatedBuildInputs = [
    convertdate
    python-dateutil
    hijri-converter
    korean-lunar-calendar
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "holidays"
  ];

  meta = with lib; {
    description = "Generate and work with holidays in Python";
    homepage = "https://github.com/dr-prodigy/python-holidays";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
