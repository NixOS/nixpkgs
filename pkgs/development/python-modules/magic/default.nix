{
  lib,
  stdenv,
  buildPythonPackage,
  pkgs,
}:

buildPythonPackage {
  format = "setuptools";
  inherit (pkgs.file) pname version src;

  patchPhase = ''
    substituteInPlace python/magic.py --replace "find_library('magic')" "'${pkgs.file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  buildInputs = [ pkgs.file ];

  preConfigure = "cd python";

  # No test suite
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper around libmagic";
    homepage = "http://www.darwinsys.com/file/";
    license = licenses.lgpl2;
  };
}
