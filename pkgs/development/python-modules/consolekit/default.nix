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
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wlZ3zaYnI2jgOF4ozlkx/8TbH51H38i2dYdBmSgt7T4=";
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
