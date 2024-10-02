{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  joblib,
  keras,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  tensorflow,
  threadpoolctl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.12.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WwB5agFBnpECvUJeJ8MZ1Y0fbPLfp1HgLtf07fZ8PBs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    joblib
    numpy
    scikit-learn
    scipy
    threadpoolctl
  ];

  optional-dependencies = {
    optional = [
      keras
      pandas
      tensorflow
    ];
  };

  pythonImportsCheck = [ "imblearn" ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # require tensorflow and keras, but we don't want to
    # add them to nativeCheckInputs just for this tests
    "imblearn/keras/_generator.py"
  ];

  meta = with lib; {
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = "https://github.com/scikit-learn-contrib/imbalanced-learn";
    changelog = "https://github.com/scikit-learn-contrib/imbalanced-learn/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
