{
  lib,
  buildPythonPackage,
  click,
  colorama,
  deprecation-alias,
  domdf-python-tools,
  fetchPypi,
  flit-core,
  mistletoe,
  psutil,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "consolekit";
  version = "1.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IOyOjl2rSsXSowbBWTgDTxoj1UOFNn0el2wrJxIE2BQ=";
  };

  build-system = [ flit-core ];

  dependencies = [
    click
    colorama
    deprecation-alias
    domdf-python-tools
    mistletoe
    typing-extensions
  ];

  optional-dependencies = {
    terminals = [ psutil ];
  };

  pythonImportsCheck = [ "consolekit" ];

  meta = {
    description = "Additional utilities for click";
    homepage = "https://github.com/domdfcoding/consolekit";
    changelog = "https://github.com/domdfcoding/consolekit/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
