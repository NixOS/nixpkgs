{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Em3dVWkSYI/iBaRUIiIRsc11pg30QAvJYwa1F/Zn9Ik=";
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
