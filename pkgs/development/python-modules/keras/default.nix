{ lib, buildPythonPackage, fetchPypi
, pytest, pytest-cov, pytest-xdist
, six, numpy, scipy, pyyaml, h5py
, keras-applications, keras-preprocessing
}:

buildPythonPackage rec {
  pname = "keras";
  version = "2.12.0";
  format = "wheel";

  src = fetchPypi {
    inherit format pname version;
    hash = "sha256-NcOVNAEekJZF+5NRVFLpjhoM4jcntV1JGLnFiyMIwV4=";
  };

  nativeCheckInputs = [
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
    changelog = "https://github.com/keras-team/keras/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
