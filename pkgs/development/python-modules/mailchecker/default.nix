{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "mailchecker";
  version = "6.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PXo6dfiAqC1WD/z5NBI6UZVUl/cwlvoqKDyfZI4fn2s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "MailChecker"
  ];

  meta = with lib; {
    description = "Module for temporary (disposable/throwaway) email detection";
    homepage = "https://github.com/FGRibreau/mailchecker";
    changelog = "https://github.com/FGRibreau/mailchecker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
