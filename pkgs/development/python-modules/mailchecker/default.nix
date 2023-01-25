{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mailchecker";
  version = "5.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u5htHCI10mn6AQDlAShMpbyI4PcqiRgpRvsy5Q3km+0=";
  };

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
