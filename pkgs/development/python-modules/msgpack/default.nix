{ buildPythonPackage
, fetchPypi
, pytest
, lib
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1109s2yynrahwi64ikax68hx0mbclz8p35afmpphw5dwynb49q7s";
  };

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest ];

  meta = {
    homepage = "https://github.com/msgpack/msgpack-python";
    description = "MessagePack serializer implementation for Python";
    changelog = "https://github.com/msgpack/msgpack-python/blob/master/ChangeLog.rst";
    license = lib.licenses.asl20;
    # maintainers =  ?? ;
  };
}
