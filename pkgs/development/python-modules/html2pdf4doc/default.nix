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
    # This software is licensed under the Apache License, Version 2.0
    # when used within the StrictDoc project.
    # For all other uses, including standalone or third-party projects,
    # the licensing terms are to be determined (TBD) and will be clarified
    # in a future update.
    # https://github.com/mettta/html2pdf4doc_python/blob/0.0.18/LICENSE
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
