{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q/hobkVdpQUoNf0e2iaJ1R3jZwqsl5mxsAz9IDkn7kU=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "dpkt" ];

  meta = {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = "https://github.com/kbandla/dpkt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bjornfor ];
    platforms = lib.platforms.all;
  };
}
