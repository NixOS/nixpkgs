{ buildPythonPackage
, fetchPypi
, pytest
, lib
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h5mxh84rcw04dvxy1qbfn2hisavfqgilh9k09rgyjhd936dad4m";
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
