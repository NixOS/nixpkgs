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
  version = "9.0.10534";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tUjASwLQy/p3Q+XnkbpUQNM6VHk94bIle2BzRd4EYsg=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace vex/Makefile-gcc --replace '/usr/bin/ar' 'ar'
  '';

  propagatedBuildInputs = [
    archinfo
    bitstring
    cffi
    future
    pycparser
  ];

  preBuild = ''
    export CC=${stdenv.cc.targetPrefix}cc
    substituteInPlace pyvex_c/Makefile --replace 'AR=ar' 'AR=${stdenv.cc.targetPrefix}ar'
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
