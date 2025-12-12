{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "ecoaliface";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z1O+Lkq1sIpjkz0N4g4FCUzTw51V4fYxlUVg+2sZ/ac=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ecoaliface" ];

  meta = {
    description = "Python library for interacting with eCoal water boiler controllers";
    homepage = "https://github.com/matkor/ecoaliface";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
