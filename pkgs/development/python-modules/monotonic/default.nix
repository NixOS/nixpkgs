{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "monotonic";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06vw7jwq96106plhlc5vz1v1xvjismdgw9wjyzvzf0ylglnrwiib";
  };

  __propagatedImpureHostDeps = stdenv.lib.optional stdenv.isDarwin "/usr/lib/libc.dylib";

  patchPhase = stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace monotonic.py --replace \
      "ctypes.util.find_library('c')" "'${stdenv.glibc.out}/lib/libc.so.6'"
  '';

  meta = with stdenv.lib; {
    description = "An implementation of time.monotonic() for Python 2 & < 3.3";
    homepage = https://github.com/atdt/monotonic;
    license = licenses.asl20;
  };

}
