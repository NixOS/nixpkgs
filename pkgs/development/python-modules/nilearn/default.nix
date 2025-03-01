{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  joblib,
  lxml,
  nibabel,
  numpy,
  pandas,
  requests,
  scikit-learn,
  scipy,
  packaging,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nilearn";
    repo = "nilearn";
    tag = version;
    hash = "sha256-ZvodSRJkKwPwpYHOLmxAYIIv7f9AlrjmZS9KLPjz5rM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --template=maint_tools/templates/index.html" ""
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    joblib
    lxml
    nibabel
    numpy
    pandas
    requests
    scikit-learn
    scipy
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/nilearn/nilearn/issues/2608
    "test_clean_confounds"

    # [XPASS(strict)] invalid checks should fail
    "test_check_estimator_invalid_group_sparse_covariance"
  ];

  # do subset of tests which don't fetch resources
  pytestFlagsArray = [ "nilearn/connectome/tests" ];

  meta = {
    description = "Module for statistical learning on neuroimaging data";
    homepage = "https://nilearn.github.io";
    changelog = "https://github.com/nilearn/nilearn/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
