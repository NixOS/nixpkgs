{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pkgs,
}:

buildPythonPackage rec {
  pname = "fusepy";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cv94PsL0PeOrOU4/dFdgW/BMjPKIovQGi0zeFB1O5r0=";
  };

  propagatedBuildInputs = [ pkgs.fuse ];

  # No tests included
  doCheck = false;

  # On macOS, users are expected to install macFUSE. This means fusepy should
  # be able to find libfuse in /usr/local/lib.
  patchPhase = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace fuse.py --replace \
      "find_library('fuse')" "'${pkgs.fuse}/lib/libfuse.so'"
  '';

  meta = with lib; {
    description = "Simple ctypes bindings for FUSE";
    longDescription = ''
      Python module that provides a simple interface to FUSE and MacFUSE.
      It's just one file and is implemented using ctypes.
    '';
    homepage = "https://github.com/terencehonles/fusepy";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
