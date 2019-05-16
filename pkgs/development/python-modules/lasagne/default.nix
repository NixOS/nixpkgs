{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, Theano
, isPy3k
}:

buildPythonPackage rec {
  pname = "Lasagne";
  version = "0.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cqj86rdm6c7y5vq3i13qy76fg5xi3yjp4r0hpqy8hvynv54wqrw";
  };

  propagatedBuildInputs = [ numpy Theano ];

  # there are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Lightweight library to build and train neural networks in Theano";
    homepage = "https://github.com/Lasagne/Lasagne";
    maintainers = with maintainers; [ NikolaMandic ];
    license = licenses.mit;
  };

}
