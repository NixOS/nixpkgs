{ lib, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f374c57bfa1cb16d1f340d270bc0d9f1f5608fb1ac6c9ea15768c0e6ece48b7";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "A JSON-RPC client library base interface";
    homepage = "https://github.com/armills/jsonrpc-base";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
