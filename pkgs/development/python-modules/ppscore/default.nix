{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pandas,
  pytestCheckHook,
  scikit-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "ppscore";
  version = "1.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "8080labs";
    repo = "ppscore";
    tag = finalAttrs.version;
    hash = "sha256-GhmyVWNWpEMNqXW808UhBHk1r6vOVibxKHVv5wWshLE=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "pandas" ];

  dependencies = [
    pandas
    scikit-learn
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # TypeError: to_datetime() got an unexpected keyword argument 'infer_datetime...
    "test__determine_case_and_prepare_df"
    "test_matrix"
  ];

  pythonImportsCheck = [ "ppscore" ];

  meta = {
    description = "Python implementation of the Predictive Power Score (PPS)";
    homepage = "https://github.com/8080labs/ppscore/";
    changelog = "https://github.com/8080labs/ppscore/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evax ];
  };
})
