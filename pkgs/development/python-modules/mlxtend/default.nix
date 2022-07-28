{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
, scipy
, numpy
, scikit-learn
, pandas
, matplotlib
, joblib
, tensorflow
, keras
}:

buildPythonPackage rec {
  pname = "mlxtend";
  version = "0.20.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ECDO3nc9IEgmZNdSA70BzOODOi0wnisI00F2Dxzdz+M=";
  };

  propagatedBuildInputs = [
    scipy
    numpy
    scikit-learn
    pandas
    matplotlib
    joblib
  ];

  checkInputs = [
    keras
    pytestCheckHook
    tensorflow
  ];

  disabledTests = [
    # ValueError: fill value must be 0 when converting to COO matrix
    "test_sparsedataframe_notzero_column"
  ];

  disabledTestPaths = [
    # import file mismatch:
    # imported module 'mlxtend.evaluate.f_test' has this __file__ attribute:
    #   /build/source/build/lib/mlxtend/evaluate/f_test.py
    # which is not the same as the test file we want to collect:
    #  /build/source/mlxtend/evaluate/f_test.py
    "mlxtend/evaluate/f_test.py"
  ];

  pythonImportsCheck = [ "mlxtend" ];

  meta = with lib; {
    description = "A library of Python tools and extensions for data science";
    homepage = "https://github.com/rasbt/mlxtend";
    license= licenses.bsd3;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
