{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pkgs,
}:

buildPythonPackage (finalAttrs: {
  pname = "fusepy";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-cv94PsL0PeOrOU4/dFdgW/BMjPKIovQGi0zeFB1O5r0=";
  };

  # On macOS, users are expected to install macFUSE. This means fusepy should
  # be able to find libfuse in /usr/local/lib.
  patchPhase = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace fuse.py --replace \
      "find_library('fuse')" "'${lib.getLib pkgs.fuse}/lib/libfuse.so'"
  '';

  build-system = [ setuptools ];

  dependencies = [ pkgs.fuse3 ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "fuse" ];

  meta = {
    description = "Simple ctypes bindings for FUSE";
    longDescription = ''
      Python module that provides a simple interface to FUSE and MacFUSE.
      It's just one file and is implemented using ctypes.
    '';
    homepage = "https://github.com/terencehonles/fusepy";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
})
