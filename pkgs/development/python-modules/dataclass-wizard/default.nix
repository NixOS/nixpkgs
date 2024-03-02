{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, pytimeparse
, pyyaml
, pytestCheckHook
, pytest-mock
, typing-extensions
}:

buildPythonPackage rec {
  pname = "dataclass-wizard";
  version = "0.22.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rnag";
    repo = "dataclass-wizard";
    rev = "v${version}";
    hash = "sha256-Ufi4lZc+UkM6NZr4bS2OibpOmMjyiBEoVKxmrqauW50=";
  };

  propagatedBuildInputs = [
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    timedelta = [
      pytimeparse
    ];
    yaml = [
      pyyaml
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ] ++ passthru.optional-dependencies.timedelta
  ++ passthru.optional-dependencies.yaml;

  disabledTests = [
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # Any/None internal changes, tests need adjusting upstream
    "without_type_hinting"
    "default_dict"
    "test_frozenset"
    "test_set"
    "date_times_with_custom_pattern"
    "from_dict_handles_identical_cased_json_keys"
  ];

  pythonImportsCheck = [ "dataclass_wizard" ];

  meta = with lib; {
    description = "A set of simple, yet elegant wizarding tools for interacting with the Python dataclasses module";
    homepage = "https://github.com/rnag/dataclass-wizard";
    changelog = "https://github.com/rnag/dataclass-wizard/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ codifryed ];
  };
}
