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
  version = "1.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YPVfZ0C4Fmz3oj2poPJPy2MMIxPkagT51Rvfe+Ajemg=";
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
    description = "Additional utilities for click.";
    homepage = "https://pypi.org/project/consolekit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
