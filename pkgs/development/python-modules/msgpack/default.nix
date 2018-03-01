{ buildPythonPackage
, fetchPypi
, pytest
, lib
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13ckbs2qc4dww7fddnm9cw116j4spgxqab49ijmj6jr178ypwl80";
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
