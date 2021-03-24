{ lib
, stdenv
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
  version = "9.0.6588";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a77d29a5fffb8ddeed092a586086c46d489a5214a1b06829f51068486b3b6be3";
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
    # ERROR: pyvex-X-py3-none-manylinux1_aarch64.whl is not a supported wheel on this platform.
    broken = stdenv.isAarch64;
  };
}
