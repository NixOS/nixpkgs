{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rpdb";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g0bw3UmKHDB2ivPTUozf6AhtjAV8n8y1Qwta7DKuFqs=";
  };

  meta = with lib; {
    description = "pdb wrapper with remote access via tcp socket";
    homepage = "https://github.com/tamentis/rpdb";
    license = licenses.bsd2;
  };
}
