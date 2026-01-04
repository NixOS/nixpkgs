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
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "dom_toml";
    hash = "sha256-CY0Btma605qj2M2Rbuocc8Qxpp5iFRHTEZwAFgTyfZ8=";
  };

  build-system = [ flit-core ];

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    domdf-python-tools
    tomli
  ];

  meta = {
    description = "Dom's tools for Tom's Obvious, Minimal Language";
    homepage = "https://github.com/domdfcoding/dom_toml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
