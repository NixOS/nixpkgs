{
  lib,
  stdenv,
  buildPythonPackage,
  pkgs,
}:

buildPythonPackage {
  name = pkgs.file.name;

  src = pkgs.file.src;

  patchPhase = ''
    substituteInPlace python/magic.py --replace "find_library('magic')" "'${pkgs.file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  buildInputs = [ pkgs.file ];

  preConfigure = "cd python";

  # No test suite
  doCheck = false;

  meta = with lib; {
    description = "A Python wrapper around libmagic";
    homepage = "http://www.darwinsys.com/file/";
    license = licenses.lgpl2;
  };
}
