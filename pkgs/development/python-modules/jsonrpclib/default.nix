{ lib
, buildPythonPackage
, fetchPypi
, cjson
, isPy3k
}:

buildPythonPackage rec {
  pname = "jsonrpclib";
  version = "0.1.7";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02vgirw2bcgvpcxhv5hf3yvvb4h5wzd1lpjx8na5psdmaffj6l3z";
  };

  propagatedBuildInputs = [ cjson ];

  meta = with lib; {
    description = "JSON RPC client library";
    homepage = https://pypi.python.org/pypi/jsonrpclib/;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.joachifm ];
  };
}
