{ lib, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "monotonic";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0";
  };

  __propagatedImpureHostDeps = lib.optional stdenv.isDarwin "/usr/lib/libc.dylib";

  patchPhase = lib.optionalString stdenv.isLinux ''
    substituteInPlace monotonic.py --replace \
      "ctypes.util.find_library('c')" "'${stdenv.glibc.out}/lib/libc.so.6'"
  '';

  meta = with lib; {
    description = "An implementation of time.monotonic() for Python 2 & < 3.3";
    homepage = "https://github.com/atdt/monotonic";
    license = licenses.asl20;
  };

}
