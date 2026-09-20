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
  version = "2.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "derek73";
    repo = "python-nameparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rNd+kVfV6poPXjctYwtBm8nf7QWnUI5LAfEcJLUdBlM=";
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
