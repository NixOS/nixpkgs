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
  version = "0.13";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xvfDq4ralIBnAtqTHZTTfNYbz6kstNOdNRtqnFIQZ1w=";
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
