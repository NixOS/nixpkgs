{ lib, buildPythonPackage, fetchPypi, pythonOlder, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5bc8ecabc05bb9d291eb5203d6810b49040f6ff446a756326104746cc00c1db";
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
