{ lib
, buildPythonPackage
, fetchPypi
, cjson
, isPy3k
}:

buildPythonPackage rec {
  pname = "jsonrpclib";
  version = "0.2.1";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8138078fd0f2a5b1df7925e4fa0b82a7c17a4be75bf5634af20463172f44f5c0";
  };

  propagatedBuildInputs = [ cjson ];

  meta = with lib; {
    description = "JSON RPC client library";
    homepage = "https://pypi.python.org/pypi/jsonrpclib/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.joachifm ];
  };
}
