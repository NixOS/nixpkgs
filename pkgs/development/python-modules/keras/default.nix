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
  version = "1.2.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bby93sffjadrxnx9j9nn2lq0ygsgqjp16260c6lz77b6r1qrcfj";
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
    homepage = "https://keras.io";
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
