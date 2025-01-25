{
  lib,
  fetchFromGitHub,
  gitUpdater,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  python-dotenv,
  pytimeparse,
  pyyaml,
  setuptools,
  tomli,
  tomli-w,
  typing-extensions,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "dataclass-wizard";
  version = "0.35.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rnag";
    repo = "dataclass-wizard";
    rev = "v${version}";
    hash = "sha256-Ed9/y2blOGYfNcmCCAe4TPWssKWUS0gxvRXKMf+cJh0=";
  };

  build-system = [ setuptools ];
  dependencies = lib.optional (pythonOlder "3.13") typing-extensions;

  optional-dependencies = {
    dotenv = [ python-dotenv ];
    timedelta = [ pytimeparse ];
    toml = [ tomli tomli-w ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ] ++ lib.concatLists (lib.attrValues optional-dependencies);

  disabledTests = [
    # TypeError: dumps() got an unexpected keyword argument 'indent'
    "test_catch_all"  # overly broad, but we're limited by pytest's selector syntax
    "test_toml_wizard_methods"
  ];

  pythonImportsCheck = [ "dataclass_wizard" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Set of simple, yet elegant wizarding tools for interacting with the Python dataclasses module";
    mainProgram = "wiz";
    homepage = "https://github.com/rnag/dataclass-wizard";
    changelog = "https://github.com/rnag/dataclass-wizard/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ codifryed ];
  };
}
