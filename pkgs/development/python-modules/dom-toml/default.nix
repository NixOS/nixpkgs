{
  lib,
  attrs,
  buildPythonPackage,
  domdf-python-tools,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  setuptools,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "dom-toml";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "dom_toml";
    tag = "v${version}";
    hash = "sha256-ukRnQecbgZBdTHhyEBIoHUwGTwQVJxo+u7Dqg4Kjvsw=";
  };

  build-system = [ flit-core ];

  dependencies = [ domdf-python-tools ];

  optional-dependencies = {
    all = [
      attrs
      tomli-w
    ];
    config = [
      attrs
      tomli-w
    ];
  };

  # Circular dependency whey -> domdf-python-tools -> coincidence
  doCheck = false;

  pythonImportsCheck = [ "dom_toml" ];

  meta = {
    description = "Dom's tools for Tom's Obvious, Minimal Language";
    homepage = "https://github.com/domdfcoding/dom_toml";
    changelog = "https://github.com/domdfcoding/dom_toml/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
