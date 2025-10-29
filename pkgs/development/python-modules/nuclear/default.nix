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
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "nuclear";
    rev = version;
    hash = "sha256-6ZuRFZLhOqS9whkD0WtWD1/xSLhE8czDA3Za7Vcn1Mc=";
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

  meta = with lib; {
    homepage = "https://igrek51.github.io/nuclear/";
    description = "Binding glue for CLI Python applications";
    license = licenses.mit;
    maintainers = with maintainers; [ parras ];
  };
}
