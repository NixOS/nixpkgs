{ lib, buildPythonPackage, fetchPypi
, pytest, pytest-cov, pytest-xdist
, six, numpy, scipy, pyyaml, h5py
, keras-applications, keras-preprocessing
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fedd729b52572fb108a98e3d97e1bac10a81d3917d2103cc20ab2a5f03beb973";
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
