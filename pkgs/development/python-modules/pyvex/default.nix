{ lib
, archinfo
, bitstring
, fetchPypi
, cffi
, buildPythonPackage
, future
, pycparser
}:

buildPythonPackage rec {
  pname = "pyvex";
  version = "9.0.5903";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa12e546599be3cce18d7daef70e93555bf681bd04f6449aa5a6e2bfebb8276b";
  };

  propagatedBuildInputs = [
    archinfo
    bitstring
    cffi
    future
    pycparser
  ];

  # No tests are available on PyPI, GitHub release has tests
  # Switch to GitHub release after all angr parts are present
  doCheck = false;
  pythonImportsCheck = [ "pyvex" ];

  meta = with lib; {
    description = "Python interface to libVEX and VEX IR";
    homepage = "https://github.com/angr/pyvex";
    license = with licenses; [ bsd2 gpl3Plus lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
