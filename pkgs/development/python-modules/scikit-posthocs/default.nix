{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, matplotlib
, numpy
, pandas
, scipy
, seaborn
, statsmodels
, pytestCheckHook
, seaborn-data
}:

buildPythonPackage rec {
  pname = "scikit-posthocs";
  version = "0.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "maximtrp";
    repo = "scikit-posthocs";
    rev = "refs/tags/v${version}";
    hash = "sha256-ojXVrsZsvX7UytldcWkhOndix4by1uBeVpG7nQrcvmA=";
  };

  patches = [
    # Fixed on master: https://github.com/maximtrp/scikit-posthocs/commit/02266a00ce0eb6a089e7efe07816da1aa5152fc9
    ./0001-increased-abs-tolerance-for-wilcoxon-test.patch
    # Fixed on master: https://github.com/maximtrp/scikit-posthocs/commit/5416ffba3ab01aebab3909400b5a9e847022898e
    ./0002-Update-test_posthocs.py.patch
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    scipy
    seaborn
    statsmodels
  ];

  preCheck = ''
    # tests require to write to home directory
    export SEABORN_DATA=${seaborn-data.exercise}
  '';
  nativeCheckInputs = [
    pytestCheckHook
  ];
  pythonImportsCheck = [ "scikit_posthocs" ];

  meta = with lib; {
    description = "Multiple Pairwise Comparisons (Post Hoc) Tests in Python";
    homepage = "https://github.com/maximtrp/scikit-posthocs";
    changelog = "https://github.com/maximtrp/scikit-posthocs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
