{
  lib,
  buildPythonPackage,
  docopt,
  fetchPypi,
  freezegun,
  pytestCheckHook,
  pythonOlder,
  selenium,
  setuptools,
}:

buildPythonPackage rec {
  pname = "httpserver";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W8Pa+CUS8vCzEcymjY6no5GMdSDSZs4bhmDtRsR4wuA=";
  };

  build-system = [ setuptools ];

  dependencies = [ docopt ];

  nativeCheckInputs = [
    freezegun
    selenium
    pytestCheckHook
  ];

  pythonImportsCheck = [ "httpserver" ];

  disabledTestPaths = [
    # Tests want driver for Firefox
    "tests/test_selenium.py"
  ];

  meta = {
    description = "Asyncio implementation of an HTTP server";
    homepage = "https://github.com/thomwiggers/httpserver";
    license = with lib.licenses; [ bsd3 ];
    maintainers = [ ];
    mainProgram = "httpserver";
  };
}
