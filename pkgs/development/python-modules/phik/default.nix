{ lib
, buildPythonPackage
, cmake
, fetchFromGitHub
, joblib
, jupyter
, jupyter-client
, matplotlib
, nbconvert
, ninja
, numba
, numpy
, pandas
, pybind11
, pytestCheckHook
, pythonOlder
, scikit-build
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "phik";
  version = "0.12.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KaveIO";
    repo = "PhiK";
    rev = "refs/tags/v${version}";
    hash = "sha256-YsH7vVn6gzejunUjUY/RIcvWtaQ/W1gbciJWKi5LDTk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
    setuptools
  ];

  propagatedBuildInputs = [
    joblib
    numpy
    scipy
    pandas
    matplotlib
    numba
    pybind11
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nbconvert
    jupyter
    jupyter-client
  ];

  # Uses setuptools to drive build process
  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "phik"
  ];

  postInstall = ''
    rm -r $out/bin
  '';

  preCheck = ''
    # import from $out
    rm -r phik
  '';

  disabledTests = [
    # TypeError: 'numpy.float64' object cannot be interpreted as an integer
    # https://github.com/KaveIO/PhiK/issues/73
    "test_significance_matrix_hybrid"
    "test_significance_matrix_mc"
  ];

  disabledTestPaths = [
    # Don't test integrations
    "tests/phik_python/integration/"
  ];

  meta = with lib; {
    description = "Phi_K correlation analyzer library";
    longDescription = ''
      Phi_K is a new and practical correlation coefficient based on several refinements to
      Pearson’s hypothesis test of independence of two variables.
    '';
    homepage = "https://phik.readthedocs.io/";
    changelog = "https://github.com/KaveIO/PhiK/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ melsigl ];
  };
}
