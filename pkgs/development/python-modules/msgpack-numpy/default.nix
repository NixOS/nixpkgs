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
  version = "0.4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31fd5dd009bbee7f8b107db8c859e3a0a2793acc196f25ffbbae1e71b4c63ca5";
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
