{ lib
, buildPythonPackage
, convertdate
, python-dateutil
, fetchPypi
, hijri-converter
, korean-lunar-calendar
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.11.3.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4855afe0ebf428efbcf848477828b889f8515be7f4f15ae26682919369d92774";
  };

  propagatedBuildInputs = [
    convertdate
    python-dateutil
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
