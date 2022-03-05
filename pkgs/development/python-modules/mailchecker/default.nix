{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mailchecker";
  version = "4.1.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ez18K9ksVGjzspHHcw/Ja6hxoKTkYLBFn65m7VBWYk=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "MailChecker"
  ];

  meta = with lib; {
    description = "Module for temporary (disposable/throwaway) email detection";
    homepage = "https://github.com/FGRibreau/mailchecker";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
