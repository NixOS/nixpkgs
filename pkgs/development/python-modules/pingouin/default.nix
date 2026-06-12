{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  mpmath,
  numpy,
  pandas-flavor,
  pandas,
  pytest-cov-stub,
  pytestCheckHook,
  scikit-learn,
  scipy,
  seaborn,
  setuptools,
  statsmodels,
  tabulate,
}:

buildPythonPackage rec {
  pname = "pingouin";
  version = "0.5.5-unstable-2025-08-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelvallat";
    repo = "pingouin";
    rev = "c939d2d4e636f7b83e95ab7844b404a0179910c2";
    hash = "sha256-IJBxO6lOaeyZBpe+HN3rewfzvNWupYdqimKEyZiVyDs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    numpy
    pandas
    pandas-flavor
    scikit-learn
    scipy
    seaborn
    statsmodels
    tabulate
  ];

  optional-dependencies = {
    extras = [ mpmath ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ]
  ++ optional-dependencies.extras;

  pythonImportsCheck = [
    "pingouin"
  ];

  meta = {
    description = "Statistical package in Python based on Pandas";
    homepage = "https://pingouin-stats.org";
    changelog = "https://pingouin-stats.org/build/html/changelog.html";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
}
