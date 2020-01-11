{ buildPythonPackage
, fetchPypi
, pytest
, lib
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea3c2f859346fcd55fc46e96885301d9c2f7a36d453f5d8f2967840efa1e1830";
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
