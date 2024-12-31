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
  version = "2.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "nuclear";
    rev = version;
    hash = "sha256-JuO7BKmlQE6bWKqy1QvX5U4A9YkKu/4ouTSJh9R7JGo=";
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
  disabledTests = [
    # Setting the time zone in nix sandbox does not work - to be investigated
    "test_context_logger"
  ];
  pythonImportsCheck = [ "nuclear" ];

  meta = with lib; {
    homepage = "https://igrek51.github.io/nuclear/";
    description = "Binding glue for CLI Python applications";
    license = licenses.mit;
    maintainers = with maintainers; [ parras ];
  };
}
