{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mailchecker";
  version = "4.1.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-58LwaVwYzjYlIB3sAkMDat1FX8wA7IiAYBwPZ0hMOdE=";
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
