{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d2f12108a147d44590c8df63997fcb32f8b2fbc18f8cbb221f0136e2e372b85";
  };

  # it will try to connect to a running instance
  doCheck = false;

  meta = with lib; {
    description = "Lightweight pure-python rpc client for deluge";
    homepage = "https://github.com/JohnDoee/deluge-client";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
