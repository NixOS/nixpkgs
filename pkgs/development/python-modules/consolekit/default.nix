{
  buildPythonPackage,
  fetchPypi,
  lib,
  flit-core,
  click,
  colorama,
  deprecation-alias,
  domdf-python-tools,
  mistletoe,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "consolekit";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gePFFOq6jQF0QA0gls1+cjdNMRutZfM2Og6/FpP0w3Q=";
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

  meta = {
    description = "Additional utilities for click";
    homepage = "https://github.com/domdfcoding/consolekit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
