{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, pytestpep8, pytest_xdist
, six, numpy, scipy, pyyaml, h5py
, keras-applications, keras-preprocessing
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90b610a3dbbf6d257b20a079eba3fdf2eed2158f64066a7c6f7227023fd60bc9";
  };

  checkInputs = [
    pytest
    pytestcov
    pytestpep8
    pytest_xdist
  ];

  propagatedBuildInputs = [
    six pyyaml numpy scipy h5py
    keras-applications keras-preprocessing
  ];

  # Keras 2.2.2 expects older versions of keras_applications
  # and keras_preprocessing. These substitutions can be removed
  # for for the next Keras release.
  postPatch = ''
    substituteInPlace setup.py --replace "keras_applications==1.0.4" "keras_applications==1.0.5"
    substituteInPlace setup.py --replace "keras_preprocessing==1.0.2" "keras_preprocessing==1.0.3"
  '';

  # Couldn't get tests working
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Deep Learning library for Theano and TensorFlow";
    homepage = https://keras.io;
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
