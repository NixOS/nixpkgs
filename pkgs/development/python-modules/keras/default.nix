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
  version = "2.0.8";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "899dc6aaed366f20100b9f80cf1093ea5b43eecc74afd1dc63a4e48dfa776ab9";
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
