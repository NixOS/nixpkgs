{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, msgpack-python
, numpy
, python
}:

buildPythonPackage rec {
  pname = "msgpack-numpy";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1czf125nixzwskiqiw0145kfj15030sp334cb89gp5w4rz3h7img";
  };

  buildInputs = [
    cython
  ];

  propagatedBuildInputs = [
   msgpack-python
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
