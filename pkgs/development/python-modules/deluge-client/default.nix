{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.10.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OIGu48Tgyp3YpWtxAEe4N+HQh6g+QhY2oHR3H5Kp8bU=";
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
