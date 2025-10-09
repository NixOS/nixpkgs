{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytoolconfig,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rope";
  version = "1.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-rope";
    repo = "rope";
    tag = version;
    hash = "sha256-LcxpJhMtyk0kT759ape9zQzdwmL1321Spdbg9zuuXtI=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytoolconfig ] ++ pytoolconfig.optional-dependencies.global;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    "test_search_submodule"
    "test_get_package_source_pytest"
    "test_get_modname_folder"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/python-rope/rope/issues/801
    "test_skipping_directories_not_accessible_because_of_permission_error"
    "test_hint_parametrized_iterable"
    "test_hint_parametrized_iterator"
  ];

  meta = with lib; {
    description = "Python refactoring library";
    homepage = "https://github.com/python-rope/rope";
    changelog = "https://github.com/python-rope/rope/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
