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
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d6da0bbb04d7cab2bf9f08f78232c954f00ac95cf2384149e779a31ce859126";
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
