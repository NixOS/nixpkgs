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
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maximtrp";
    repo = "scikit-posthocs";
    rev = "refs/tags/v${version}";
    hash = "sha256-sRop5DKakrZEBswzTvumn68wKqU15zM5aCLfZ/PdsFg=";
  };

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
