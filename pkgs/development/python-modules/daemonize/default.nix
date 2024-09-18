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
    sha256 = "1hwbl3gf9fdds9sc14zgjyjisjvxidrvqc11xlbb0b6jz17nw0nx";
  };

  meta = with lib; {
    description = "Library to enable your code run as a daemon process on Unix-like systems";
    homepage = "https://github.com/thesharp/daemonize";
    license = licenses.mit;
  };
}
