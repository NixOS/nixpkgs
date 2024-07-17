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
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dqi84qeUGirw4z1ay3burLeHESeNK2DDPtPnpJzD/Qw=A";
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

  nativeCheckInputs = [ ];

  meta = {
    description = "Additional utilities for click.";
    homepage = "https://pypi.org/project/consolekit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
