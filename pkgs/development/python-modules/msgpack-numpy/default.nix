{ lib
, buildPythonPackage
, fetchPypi
, cython
, msgpack
, numpy
, python
}:

buildPythonPackage rec {
  pname = "msgpack-numpy";
  version = "0.4.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7eaf51acf82d7c467d21aa71df94e1c051b2055e54b755442051b474fa7cf5e1";
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

  meta = with lib; {
    description = "Numpy data type serialization using msgpack";
    homepage = "https://github.com/lebedov/msgpack-numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aborsu ];
  };
}
