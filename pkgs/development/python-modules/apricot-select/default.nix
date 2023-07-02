{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, numpy
, scipy
, numba
, tqdm
, scikit-learn
, torch
}:

buildPythonPackage {
  pname = "apricot-select";
  version = "0.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jmschrei";
    repo = "apricot";
    # releases are not tagged, tests missing from pypi archive
    rev = "bf86e699e6929127ccb5876d8c62c70785390eb0";
    hash = "sha256-v9BHFxmlbwXVipPze/nV35YijdFBuka3gAl85AlsffQ=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    numba
    tqdm
    # depedencies missing from setup.py
    scikit-learn
    torch
  ];

  pythonRemoveDeps = [
    "nose" # only for tests
  ];

  doCheck = false; # tests take too long

  pythonImportsCheck = [
    "apricot"
  ];

  meta = with lib; {
    description = "Submodular selection of representative sets for machine learning models";
    homepage = "https://github.com/jmschrei/apricot";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
