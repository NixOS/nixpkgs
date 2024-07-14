{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "daemonize";
  version = "2.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3QJuT/jSLLAW7SEwvHOLfUsdpZfvk8B00q255N6gi8M=";
  };

  meta = with lib; {
    description = "Library to enable your code run as a daemon process on Unix-like systems";
    homepage = "https://github.com/thesharp/daemonize";
    license = licenses.mit;
  };
}
