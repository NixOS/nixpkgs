{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  requests,
  selenium,
  versionCheckHook,
  webdriver-manager,
}:

buildPythonPackage rec {
  pname = "html2pdf4doc";
  version = "0.0.18";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wxn0fyUuPE9ctz3CI25EmUH8YybQ9dkrZIM6FGJBb9s=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    selenium
    webdriver-manager
  ];

  pythonImportsCheck = [ "html2pdf4doc" ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "-v";

  meta = {
    description = "Python client for HTML2PDF4Doc JavaScript library";
    homepage = "https://pypi.org/project/html2pdf4doc";
    mainProgram = "html2pdf4doc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
