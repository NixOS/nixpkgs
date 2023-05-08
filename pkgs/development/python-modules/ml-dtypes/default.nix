{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pybind11
}:

buildPythonPackage rec {
  pname = "ml_dtypes";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wfwK/mPOmQafnX4Gk6Yc/QrqkCQfw4Ia+ZU9DBH0BIo=";
  };

  propagatedBuildInputs = [
    numpy
    pybind11
  ];

  pythonImportsCheck = [
    "ml_dtypes"
  ];

  meta = with lib; {
    description = "A stand-alone implementation of several NumPy dtype extensions used in machine learning.";
    homepage = "https://github.com/jax-ml/ml_dtypes";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlthome ];
  };
}
