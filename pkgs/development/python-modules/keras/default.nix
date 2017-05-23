{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
, pytestpep8
, pytest_xdist
, six
, Theano
, tensorflow ? null
, tensorflowWithCuda ? null
, pyyaml
}:

let tf = if tensorflowWithCuda != null then tensorflowWithCuda else tensorflow;
in buildPythonPackage rec {
  pname = "Keras";
  version = "2.0.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x4p179smmnki6mng9n3lsi9glv2jg0y1ls154msplz9jm5bv39r";
  };

  checkInputs = [
    pytest
    pytestcov
    pytestpep8
    pytest_xdist
  ];

  propagatedBuildInputs = [
    six Theano pyyaml tf
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
