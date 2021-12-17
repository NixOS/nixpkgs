{ lib
, buildPythonPackage
, fetchPypi
, joblib
, llvmlite
, numba
, scikit-learn
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pynndescent";
  version = "0.5.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a7df8412b19cfb3596060faf5a8c5d0bf5b3bd504f8efd900fc4e3918c6f882";
  };

  propagatedBuildInputs = [
    joblib
    llvmlite
    numba
    scikit-learn
    scipy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Nearest Neighbor Descent";
    homepage = "https://github.com/lmcinnes/pynndescent";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mic92 ];
  };
}
