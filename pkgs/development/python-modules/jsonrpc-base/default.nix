{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dl55n54ha5kf4x6hap2p1k3s4qa4w7g791wp2656rjg2zxfgywk";
  };

  propagatedBuildInputs = [ ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library base interface";
    homepage = https://github.com/armills/jsonrpc-base;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
