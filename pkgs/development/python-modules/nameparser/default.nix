{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  hypothesis,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "nameparser";
  version = "2.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "derek73";
    repo = "python-nameparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MDzw2F9oH6cvvIYxYRv85+e61uGYFDWubfJ+WP8h7mQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pytest-timeout
  ];

  disabledTests = [
    # Flaky when build system is under dynamic load
    "test_parse_cost_grows_no_worse_than_linearly"
    "test_policy_gated_cost_grows_no_worse_than_linearly"
  ];

  pythonImportsCheck = [ "nameparser" ];

  meta = {
    description = "Module for parsing human names into their individual components";
    homepage = "https://github.com/derek73/python-nameparser";
    changelog = "https://github.com/derek73/python-nameparser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
})
