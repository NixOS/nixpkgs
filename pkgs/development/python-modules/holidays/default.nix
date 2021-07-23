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
  version = "0.11.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nqxan6nr3jp63i3sbb9s1v5dlig22bl927a6pl1ahks8cnr7rkn";
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
