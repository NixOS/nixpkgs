{ lib, buildPythonPackage, fetchPypi, pythonOlder, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05a85c2872edf37a4ed30b0cce2f6093e1d0581f8c19d7393122da7e25b2b24c";
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
