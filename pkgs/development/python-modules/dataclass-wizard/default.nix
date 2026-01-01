{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-mock,
  pytestCheckHook,
  python-dotenv,
  pythonAtLeast,
  pythonOlder,
  pytimeparse,
  pyyaml,
  setuptools,
  typing-extensions,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "dataclass-wizard";
<<<<<<< HEAD
  version = "0.38.2";
=======
  version = "0.35.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rnag";
    repo = "dataclass-wizard";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/Afw7O7BNKUyg7lGP5CgkkOijaLfQsEqhDkBU7z8l+o=";
=======
    hash = "sha256-GnD0Rxvy46+SLP5oFYVPO4+4VSBAPPRip//8e7xyylA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Wizarding tools for interacting with the Python dataclasses module";
    homepage = "https://github.com/rnag/dataclass-wizard";
    changelog = "https://github.com/rnag/dataclass-wizard/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codifryed ];
=======
  meta = with lib; {
    description = "Wizarding tools for interacting with the Python dataclasses module";
    homepage = "https://github.com/rnag/dataclass-wizard";
    changelog = "https://github.com/rnag/dataclass-wizard/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ codifryed ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "wiz";
  };
}
