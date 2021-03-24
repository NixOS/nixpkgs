{ lib, buildPythonPackage, fetchPypi, pythonOlder, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e59fd8e750e588358f1b8885e5a4751203a0516e0ee6d34811089ac294c8806f";
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
