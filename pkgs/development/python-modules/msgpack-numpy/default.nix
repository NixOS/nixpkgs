{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, msgpack
, numpy
, python
}:

buildPythonPackage rec {
  pname = "msgpack-numpy";
  version = "0.4.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac15d3a7b9e29d3e10a2683dc00ea495891b9b4cbb502ab0b0d2e516bd0b2eab";
  };

  buildInputs = [
    cython
  ];

  propagatedBuildInputs = [
   msgpack
   numpy
  ];

  checkPhase = ''
    ${python.interpreter} msgpack_numpy.py
  '';

  meta = with stdenv.lib; {
    description = "Practical Machine Learning for NLP in Python";
    homepage = https://github.com/lebedov/msgpack-numpy;
    license = licenses.bsd3;
    maintainers = with maintainers; [ aborsu ];
  };
}
