{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a95d5bc3cf12e842793cb90eecef5c91f4bd8a7fc4e1e8fdef36d62b643d87cb";
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
