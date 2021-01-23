{ lib, stdenv, buildPythonPackage, fetchPypi, pythonOlder, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35b2d75ee967ea93b55750aa9edbbf72813e06a66ba54438df2cfac9e3c27fc8";
  };

  checkInputs = [ unittest2 ];

  # some tests are output dependent, which have changed slightly
  doCheck = pythonOlder "3.9";

  meta = with lib; {
    homepage = "https://launchpad.net/pyflakes";
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
