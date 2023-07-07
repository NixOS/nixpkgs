{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, cython
, scipy
, scikit-learn
, matplotlib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scikit-learn-extra";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "scikit-learn-contrib";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-dHOwo6NIuhcvIehpuJQ621JEg5O3mnXycAhpTZKaxns=";
  };

  nativeBuildInputs = [ numpy cython ];
  propagatedBuildInputs = [ numpy scipy scikit-learn ];
  nativeCheckInputs = [ matplotlib pytestCheckHook ];

  preCheck = ''
    # Remove the package in the build dir, because Python defaults to it and
    # ignores the one in Nix store with cythonized modules.
    rm -r sklearn_extra
  '';

  pytestFlagsArray = [ "--pyargs sklearn_extra" ];
  disabledTestPaths = [
    "benchmarks"
    "examples"
    "doc"
  ];
  disabledTests = [
    "build"   # needs network connection
    "test_all_estimators" # sklearn.exceptions.NotFittedError: Estimator fails to pass `check_is_fitted` even though it has been fit.
  ];

  # Check packages with cythonized modules
  pythonImportsCheck = [
    "sklearn_extra"
    "sklearn_extra.cluster"
    "sklearn_extra.robust"
    "sklearn_extra.utils"
  ];

  meta = {
    description = "A set of tools for scikit-learn";
    homepage = "https://github.com/scikit-learn-contrib/scikit-learn-extra";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
