{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mailchecker";
  version = "4.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vr70AB8EiOmb8lgwrq78iTnHdrp14Ppyh57Trh8SQ8Q=";
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
