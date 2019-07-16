{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ragmpihjr9p6n27hw7gy83qyc68csqpn18m9kvwsby1vi7mgdy8";
  };

  # it will try to connect to a running instance
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Lightweight pure-python rpc client for deluge";
    homepage = https://github.com/JohnDoee/deluge-client;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
