{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "iowait";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16djvxd9sxm7cr57clhqkyrq3xvdzgwj803sy5hwyb62hkmw46xb";
  };

  meta = {
    description = "Platform-independent module for I/O completion events";
    homepage = https://launchpad.net/python-iowait;
  };
}
