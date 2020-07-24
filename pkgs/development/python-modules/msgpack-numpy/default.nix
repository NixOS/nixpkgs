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
  version = "0.4.6.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfcb0c9cb5850e656344ac464a260e7b8b9b1c62d77c2e1d3d9ef15a88f1df6b";
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
    description = "Numpy data type serialization using msgpack";
    homepage = "https://github.com/lebedov/msgpack-numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aborsu ];
  };
}
