{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  joblib,
  keras,
  numpy,
  pandas,
  scikit-learn,
  sklearn-compat,
  scipy,
  tensorflow,
  threadpoolctl,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-learn-contrib";
    repo = "imbalanced-learn";
    rev = "refs/tags/${version}";
    hash = "sha256-osmALi5vTV+3kgldY/VhYkNvpXX11KwJ/dIX/5E7Uhc=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    joblib
    numpy
    scikit-learn
    sklearn-compat
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
    # The GitHub source contains too many files picked up by pytest like
    # examples and documentation files which can't pass.
    cd $out/${python.sitePackages}
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
