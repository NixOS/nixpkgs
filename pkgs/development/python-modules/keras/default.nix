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
