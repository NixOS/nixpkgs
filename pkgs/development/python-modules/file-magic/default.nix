{
  lib,
  stdenv,
  buildPythonPackage,
  pkgs,
}:

buildPythonPackage {
  pname = "file-magic";
  format = "setuptools";
  inherit (pkgs.file) version src;

  patchPhase = ''
    substituteInPlace python/magic.py --replace "find_library('magic')" "'${pkgs.file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  buildInputs = [ pkgs.file ];

  preConfigure = "cd python";

  # No test suite
  doCheck = false;

  # Python package version doesn't correspond to file's version
  dontCheckPythonMetadata = true;

  meta = {
    description = "Python wrapper around libmagic";
    homepage = "http://www.darwinsys.com/file/";
    license = lib.licenses.lgpl2;
  };
}
