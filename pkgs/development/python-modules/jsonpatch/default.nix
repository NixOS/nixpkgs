{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonpointer
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonpatch";
  version = "1.32";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stefankoegl";
    repo = "python-json-patch";
    rev = "v${version}";
    hash = "sha256-JMGBgYjnjHQ5JpzDwJcR2nVZfzmQ8ZZtcB0GsJ9Q4Jc=";
  };

  propagatedBuildInputs = [
    jsonpointer
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsonpatch"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  meta = with lib; {
    description = "Library to apply JSON Patches according to RFC 6902";
    homepage = "https://github.com/stefankoegl/python-json-patch";
    license = licenses.bsd2; # "Modified BSD license, says pypi"
    maintainers = with maintainers; [ ];
  };
}
