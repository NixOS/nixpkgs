{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "2.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "nuclear";
    rev = version;
    hash = "sha256-hoOvISKjl5XTxtv8I3BSkOI7oZFSL+yA3NiYceJGcIY=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/igrek51/nuclear/commit/e6930046d1312f92e231ec8e2b435bc184a75823.patch";
      hash = "sha256-roE4ZGK1TeVupJL9KQYZtY+lZtRgJ03AQNKrT1F5ajc=";
    })
  ];

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
