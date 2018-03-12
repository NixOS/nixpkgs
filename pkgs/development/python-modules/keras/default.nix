{ stdenv, lib, buildPythonPackage, fetchPypi
, pytest, pytestcov, pytestpep8, pytest_xdist
, six, numpy, scipy, pyyaml
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.1.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ee1fcc79072ac904a4f008d715bcb78c60250ae3cd41d99e268c60ade8d0d3a";
  };

  checkInputs = [
    pytest
    pytestcov
    pytestpep8
    pytest_xdist
  ];

  propagatedBuildInputs = [
    six pyyaml numpy scipy
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
