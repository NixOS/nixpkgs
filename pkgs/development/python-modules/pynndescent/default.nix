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
  version = "0.5.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "221124cbad8e3cf3ed421a4089d80ac5a29d3215e76cb49effc1df887533d2a8";
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
