{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bda99589b4566f5027c2aeae122f409d8ccf4c811b278b8cfb616903871efb2";
  };

  propagatedBuildInputs = [ ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library base interface";
    homepage = https://github.com/armills/jsonrpc-base;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
