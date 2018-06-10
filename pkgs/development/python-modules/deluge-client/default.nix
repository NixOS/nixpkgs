{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86979ebcb9f1f991554308e88c7a57469cbf339958b44c71cbdcba128291b043";
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
