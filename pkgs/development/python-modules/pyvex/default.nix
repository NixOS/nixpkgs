{ lib
, stdenv
, archinfo
, bitstring
, buildPythonPackage
, cffi
, fetchPypi
, future
, pycparser
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvex";
  version = "9.1.12332";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e1lruHgppQ8mJbTx6xsUDSkLCYQISqM9c1vsjdQU4eI=";
  };

  propagatedBuildInputs = [
    archinfo
    bitstring
    cffi
    future
    pycparser
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace vex/Makefile-gcc \
      --replace '/usr/bin/ar' 'ar'
  '';

  setupPyBuildFlags = lib.optionals stdenv.isLinux [
    "--plat-name"
    "linux"
  ];

  preBuild = ''
    export CC=${stdenv.cc.targetPrefix}cc
    substituteInPlace pyvex_c/Makefile \
      --replace 'AR=ar' 'AR=${stdenv.cc.targetPrefix}ar'
  '';

  # No tests are available on PyPI, GitHub release has tests
  # Switch to GitHub release after all angr parts are present
  doCheck = false;

  pythonImportsCheck = [
    "pyvex"
  ];

  meta = with lib; {
    description = "Python interface to libVEX and VEX IR";
    homepage = "https://github.com/angr/pyvex";
    license = with licenses; [ bsd2 gpl3Plus lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
