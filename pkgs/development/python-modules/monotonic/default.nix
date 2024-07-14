{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "monotonic";
  version = "1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OlUge8/tU93VxbrhdFJAYpNe/tF3kuneKtAgXOmtY/c=";
  };

  __propagatedImpureHostDeps = lib.optional stdenv.isDarwin "/usr/lib/libc.dylib";

  patchPhase = lib.optionalString stdenv.isLinux ''
    substituteInPlace monotonic.py --replace \
      "ctypes.util.find_library('c')" "'${stdenv.cc.libc}/lib/libc.so'"
  '';

  meta = with lib; {
    description = "Implementation of time.monotonic() for Python 2 & < 3.3";
    homepage = "https://github.com/atdt/monotonic";
    license = licenses.asl20;
  };
}
