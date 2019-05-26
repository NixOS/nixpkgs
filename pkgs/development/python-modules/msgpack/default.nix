{ buildPythonPackage
, fetchPypi
, pytest
, lib
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4008c72f5ef2b7936447dcb83db41d97e9791c83221be13d5e19db0796df1972";
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
