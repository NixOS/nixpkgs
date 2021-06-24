{ lib
, stdenv
, archinfo
, bitstring
, buildPythonPackage
, cffi
, fetchPypi
, future
, pycparser
}:

buildPythonPackage rec {
  pname = "pyvex";
  version = "9.0.6281";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E8BYCzV71qVNRzWCCI2yTVU88JVMA08eqnIO8OtbNlM=";
  };

  propagatedBuildInputs = [
    archinfo
    bitstring
    cffi
    future
    pycparser
  ];

  postPatch = ''
    substituteInPlace pyvex_c/Makefile \
      --replace "CC=gcc" "CC=${stdenv.cc.targetPrefix}cc"
  '';

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
