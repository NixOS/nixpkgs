{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  matplotlib,
  networkx,
  numpy,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scikit-fuzzy";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-fuzzy";
    repo = "scikit-fuzzy";
    tag = "v${version}";
    hash = "sha256-02aIYBdbQXQD9S1R/gZZeKTn5LxloE0GGGRttxJnR/o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    networkx
    numpy
    scipy
  ];

  nativeCheckInputs = [
    matplotlib
    pytestCheckHook
  ];

  preCheck = "rm -rf build";

  pythonImportsCheck = [ "skfuzzy" ];

  meta = {
    homepage = "https://github.com/scikit-fuzzy/scikit-fuzzy";
    description = "Fuzzy logic toolkit for scientific Python";
    changelog = "https://github.com/scikit-fuzzy/scikit-fuzzy/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
