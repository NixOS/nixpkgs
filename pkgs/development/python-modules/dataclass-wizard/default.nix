{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-mock,
  pytestCheckHook,
  python-dotenv,
  pythonAtLeast,
  pytimeparse,
  pyyaml,
  setuptools,
  typing-extensions,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "dataclass-wizard";
  version = "0.39.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rnag";
    repo = "dataclass-wizard";
    tag = "v${version}";
    hash = "sha256-X4/qe1nv/NwUvQGvVqbqIgi9Ej43jwJjzXyMaKAtN2A=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    dotenv = [ python-dotenv ];
    timedelta = [ pytimeparse ];
    toml = [ tomli-w ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests =
    [ ]
    ++ lib.optionals (pythonAtLeast "3.11") [
      # Any/None internal changes, tests need adjusting upstream
      "without_type_hinting"
      "default_dict"
      "test_frozenset"
      "test_set"
      "date_times_with_custom_pattern"
      "from_dict_handles_identical_cased_json_keys"
    ];

  pythonImportsCheck = [ "dataclass_wizard" ];

  meta = {
    description = "Wizarding tools for interacting with the Python dataclasses module";
    homepage = "https://github.com/rnag/dataclass-wizard";
    changelog = "https://github.com/rnag/dataclass-wizard/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codifryed ];
    mainProgram = "wiz";
  };
}
