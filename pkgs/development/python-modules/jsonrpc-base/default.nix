{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a583a6646cf3860a427d56ea6732e04618a919c5ea4a78d3dcb44d866c11a8e5";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "A JSON-RPC client library base interface";
    homepage = "https://github.com/armills/jsonrpc-base";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
