{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, text-unidecode
, unidecode
}:

buildPythonPackage rec {
  pname = "python-slugify";
  version = "6.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7/GQ5N+sl9L4wYkO5oJwns0jZQdCNhaH24LZXh5eJfU=";
  };

  propagatedBuildInputs = [
    text-unidecode
    unidecode
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  pythonImportsCheck = [
    "slugify"
  ];

  meta = with lib; {
    description = "Python Slugify application that handles Unicode";
    homepage = "https://github.com/un33k/python-slugify";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
