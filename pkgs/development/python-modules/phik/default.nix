{ lib
, buildPythonPackage
, cmake
, fetchFromGitHub
, isPy3k
, pytestCheckHook
, nbconvert
, joblib
, jupyter
, jupyter-client
, numpy
, scipy
, pandas
, matplotlib
, ninja
, numba
, pybind11
, scikit-build
}:

buildPythonPackage rec {
  pname = "phik";
  version = "0.12.3";
  disabled = !isPy3k;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KaveIO";
    repo = "PhiK";
    rev = "refs/tags/v${version}";
    hash = "sha256-9o3EDhgmne2J1QfzjjNQc1mUcyCzoVrCnWXqjWkiZU0=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    nbconvert
    jupyter
    jupyter-client
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

  # uses setuptools to drive build process
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
  ];

  pythonImportsCheck = [ "phik" ];

  postInstall = ''
    rm -r $out/bin
  '';

  preCheck = ''
    # import from $out
    rm -r phik
  '';

  meta = with lib; {
    description = "Phi_K correlation analyzer library";
    longDescription = "Phi_K is a new and practical correlation coefficient based on several refinements to Pearson’s hypothesis test of independence of two variables.";
    homepage = "https://phik.readthedocs.io/en/latest/";
    changelog = "https://github.com/KaveIO/PhiK/blob/${src.rev}/CHANGES.rst";
    maintainers = with maintainers; [ melsigl ];
    license = licenses.asl20;
  };
}
