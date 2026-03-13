{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  colorama,
  mock,
  pyyaml,
  pydantic,
  backoff,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nuclear";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "nuclear";
    rev = version;
    hash = "sha256-xKsYS+v/7xm9LRdpFKMsbrPggw4VfVMWst/3olj2n3E=";
  };

  build-system = [ setuptools ];
  dependencies = [
    colorama
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pydantic
    backoff
  ];
  disabledTestPaths = [
    # Disabled because test tries to install bash in a non-NixOS way
    "tests/autocomplete/test_bash_install.py"
  ];
  pythonImportsCheck = [ "nuclear" ];

  meta = {
    homepage = "https://igrek51.github.io/nuclear/";
    description = "Binding glue for CLI Python applications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ parras ];
  };
}
