{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  hatch-vcs,
  lxml,
  matplotlib,
  nibabel,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  joblib,
  requests,
}:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.11.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oB3wj8bI3tPNb7eiEWNGA61Gpt94BQS20FIiwuepcv4=";
  };

  nativeBuildInputs = [ hatch-vcs ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [ "test_clean_confounds" ]; # https://github.com/nilearn/nilearn/issues/2608
  # do subset of tests which don't fetch resources
  pytestFlagsArray = [ "nilearn/connectome/tests" ];

  propagatedBuildInputs = [
    joblib
    lxml
    matplotlib
    nibabel
    numpy
    pandas
    requests
    scikit-learn
    scipy
  ];

  meta = with lib; {
    homepage = "https://nilearn.github.io";
    description = "Module for statistical learning on neuroimaging data";
    changelog = "https://github.com/nilearn/nilearn/releases/tag/${version}";
    license = licenses.bsd3;
  };
}
