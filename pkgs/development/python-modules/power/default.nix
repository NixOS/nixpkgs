{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "power";
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fX1g7DMqy+On0AN5tF45q/ZQv37jEdYdpauSH1LwYPA=";
  };

  # Tests can't work because there is no power information available.
  doCheck = false;

  meta = with lib; {
    description = "Cross-platform system power status information";
    homepage = "https://github.com/Kentzo/Power";
    license = licenses.mit;
  };
}
