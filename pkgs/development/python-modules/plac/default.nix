{ lib
, buildPythonPackage
, fetchPypi
, unittestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "plac";
  version = "1.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OL3YZNBFD7dIGTqoF7nEWKj1MZ+/l7ImEVHPwKWBIJA=";
  };

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "doc" "-p" "*test_plac*" ];

  pythonImportsCheck = [
    "plac"
  ];

  meta = with lib; {
    description = "Parsing the Command Line the Easy Way";
    homepage = "https://github.com/micheles/plac";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
