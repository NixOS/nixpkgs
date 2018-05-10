{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27a7f4c6da8f057e03171a493f17340f39f288199a21beb3226a188ab3c02cea";
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
