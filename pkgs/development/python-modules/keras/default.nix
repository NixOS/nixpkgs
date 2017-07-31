{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
, pytestpep8
, pytest_xdist
, six
, Theano
, pyyaml
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.0.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0519480abe4ad18b2c2d1bc580eab75edd82c95083d341a1157952f4b00019bb";
  };

  checkInputs = [
    pytest
    pytestcov
    pytestpep8
    pytest_xdist
  ];

  propagatedBuildInputs = [
    six Theano pyyaml
  ];

  # Couldn't get tests working
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Deep Learning library for Theano and TensorFlow";
    homepage = https://keras.io;
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
