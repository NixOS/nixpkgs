{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21f860c915617f6475aa1ac5a1ec11de03cce6b279741f25ad97d8a4c5b76c3c";
  };

  propagatedBuildInputs = [ ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library base interface";
    homepage = https://github.com/armills/jsonrpc-base;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
