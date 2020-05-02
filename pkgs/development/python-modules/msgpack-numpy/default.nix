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
    sha256 = "0z3ls52iamqv6fbn1ljnd5nnnzaiakczciry5c3vym5r77wgc9mg";
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
