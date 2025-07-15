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
  version = "0.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maximtrp";
    repo = "scikit-posthocs";
    tag = "v${version}";
    hash = "sha256-W1jm9mKJCwTPihZhtuCIM3HILT/nXLXbTjR+E2nwsug=";
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

  meta = with lib; {
    description = "Multiple Pairwise Comparisons (Post Hoc) Tests in Python";
    homepage = "https://github.com/maximtrp/scikit-posthocs";
    changelog = "https://github.com/maximtrp/scikit-posthocs/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
