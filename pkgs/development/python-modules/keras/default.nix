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
  version = "2.0.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6c72ee2b94be1ffefe7e77b69582b9827211f0c356b2189459711844d3634c0";
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
