{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flit-core
, domdf-python-tools
, toml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dom-toml";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "dom_toml";
    rev = "v${version}";
    hash = "sha256-1K/u/nmTG8e1PqwZnt4ttype/RqX13vk9ONvVWY+lnI=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    domdf-python-tools
    toml
  ];

  pythonImportsCheck = [ "dom_toml" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Dom's tools for Tom's Obvious, Minimal Language";
    homepage = "https://github.com/domdfcoding/dom_toml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
