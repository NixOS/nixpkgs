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
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af26f6f839b954bf072b3e47f6d954517d6b6d6956d26097331b571545d1747c";
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
