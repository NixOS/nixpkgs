{ lib
, buildPythonPackage
, convertdate
, dateutil
, fetchPypi
, hijri-converter
, korean-lunar-calendar
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.11.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f6/YRvZ/Drfh+cGcOPSnlnvweu1d7S3XqKovk3sOoBs=";
  };

  propagatedBuildInputs = [
    convertdate
    dateutil
    hijri-converter
    korean-lunar-calendar
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "holidays" ];

  meta = with lib; {
    homepage = "https://github.com/dr-prodigy/python-holidays";
    description = "Generate and work with holidays in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
