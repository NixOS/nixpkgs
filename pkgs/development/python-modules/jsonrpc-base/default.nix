{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9baac32aa51c3052d03b86ff30a9856900b8b4a4eb175f7bf2c8722520b8637";
  };

  propagatedBuildInputs = [ ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library base interface";
    homepage = https://github.com/armills/jsonrpc-base;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
