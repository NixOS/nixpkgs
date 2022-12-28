{ lib, buildPythonPackage, fetchPypi
, pytest, pytest-cov, pytest-xdist
, six, numpy, scipy, pyyaml, h5py
, keras-applications, keras-preprocessing
}:

buildPythonPackage rec {
  pname = "keras";
  version = "2.10.0";
  format = "wheel";

  src = fetchPypi {
    inherit format pname version;
    sha256 = "sha256-JqbiwlIudGjd6iJxCpmzKQSTdo/AijnnXRFzoONFL98=";
  };

  checkInputs = [
    pytest
    pytest-cov
    pytest-xdist
  ];

  propagatedBuildInputs = [
    six pyyaml numpy scipy h5py
    keras-applications keras-preprocessing
  ];

  # Couldn't get tests working
  doCheck = false;

  meta = with lib; {
    description = "Deep Learning library for Theano and TensorFlow";
    homepage = "https://keras.io";
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
