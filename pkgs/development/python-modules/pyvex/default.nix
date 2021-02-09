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
  version = "9.0.5739";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jwxxw2kw7wkz7kh8m8vbavzw6m5k6xph7mazfn3k2qbsshh3lk3";
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
