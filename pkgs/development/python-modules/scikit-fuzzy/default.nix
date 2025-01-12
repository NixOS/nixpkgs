{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  matplotlib,
  networkx,
  numpy,
  scipy,
  pytest7CheckHook,
}:

buildPythonPackage {
  pname = "scikit-fuzzy";
  version = "0.4.2-unstable-2023-09-14";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "scikit-fuzzy";
    repo = "scikit-fuzzy";
    rev = "d7551b649f34c2f5e98836e9b502279226d3b225";
    hash = "sha256-91Udm2dIaIwTVG6V1EqYA/4qryuS4APgaa7tIa3sSQE=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    networkx
    numpy
    scipy
  ];

  nativeCheckInputs = [
    matplotlib
    pytest7CheckHook
  ];

  preCheck = "rm -rf build";

  pythonImportsCheck = [ "skfuzzy" ];

  meta = with lib; {
    homepage = "https://github.com/scikit-fuzzy/scikit-fuzzy";
    description = "Fuzzy logic toolkit for scientific Python";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
