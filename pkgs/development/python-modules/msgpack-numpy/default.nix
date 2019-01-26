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
  version = "0.4.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1638108538aaba55bebaef9d847dfb3064bb1c829e68301716a6a956fa6a0d6";
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
