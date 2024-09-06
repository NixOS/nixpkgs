{
  buildPythonPackage,
  fetchPypi,
  lib,
  flit-core,
  setuptools,
  domdf-python-tools,
  tomli,
}:
buildPythonPackage rec {
  pname = "dom-toml";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "dom_toml";
    hash = "sha256-PAfoQ2U4mUl0Ensa4DdmHRp3mskVxE/Qazq1/hQP9Yk=";
  };

  build-system = [ flit-core ];

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    domdf-python-tools
    tomli
  ];

  nativeCheckInputs = [ ];

  meta = {
    description = "Dom's tools for Tom's Obvious, Minimal Language.";
    homepage = "https://github.com/domdfcoding/dom_toml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
