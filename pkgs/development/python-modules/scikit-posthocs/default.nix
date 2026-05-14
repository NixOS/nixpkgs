{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  matplotlib,
  numpy,
  pandas,
  scipy,
  seaborn,
  statsmodels,
  pytestCheckHook,
  seaborn-data,
}:

buildPythonPackage rec {
  pname = "scikit-posthocs";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maximtrp";
    repo = "scikit-posthocs";
    tag = "v${version}";
    hash = "sha256-+W4cqScoM9KN4as83G+9fyJuNzOEcM1VpGWhvn/AdFc=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "scikit_posthocs" ];

  meta = {
    description = "Multiple Pairwise Comparisons (Post Hoc) Tests in Python";
    homepage = "https://github.com/maximtrp/scikit-posthocs";
    changelog = "https://github.com/maximtrp/scikit-posthocs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
