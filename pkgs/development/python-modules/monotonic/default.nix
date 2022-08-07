{ lib, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "monotonic";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a55207bcfed53ddd5c5bae174524062935efed17792e9de2ad0205ce9ad63f7";
  };

  __propagatedImpureHostDeps = lib.optional stdenv.isDarwin "/usr/lib/libc.dylib";

  patchPhase = lib.optionalString stdenv.isLinux ''
    substituteInPlace monotonic.py --replace \
      "ctypes.util.find_library('c')" "'${stdenv.cc.libc}/lib/libc.so'"
  '';

  meta = with lib; {
    description = "An implementation of time.monotonic() for Python 2 & < 3.3";
    homepage = "https://github.com/atdt/monotonic";
    license = licenses.asl20;
  };

}
