{ buildPythonPackage
, fetchPypi
, pytest
, lib
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3";
  };

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest ];

  meta = {
    homepage = https://github.com/msgpack/msgpack-python;
    description = "MessagePack serializer implementation for Python";
    license = lib.licenses.asl20;
    # maintainers =  ?? ;
  };
}
