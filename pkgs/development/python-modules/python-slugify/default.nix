{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, python
, pythonOlder
, text-unidecode
, unidecode
}:

buildPythonPackage rec {
  pname = "python-slugify";
  version = "5.0.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8TODoLn8vmSaGJK5yOtPjqsdbYS4S7emJDF6+pgVnKs=";
  };

  propagatedBuildInputs = [
    text-unidecode
    unidecode
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test.py" ];

  pythonImportsCheck = [ "slugify" ];

  meta = with lib; {
    description = "Python Slugify application that handles Unicode";
    homepage = "https://github.com/un33k/python-slugify";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
