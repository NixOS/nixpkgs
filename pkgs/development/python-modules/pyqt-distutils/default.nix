{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
let
  pname = "pyqt-distutils";
  version = "0.7.3";
in
buildPythonPackage {
  inherit pname version;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7luMMNOwpHOlwj5DsqKc6OR/p7SNjckYFpU9o3vAU+g=";
  };
  meta = {
    description = "Distutils extensions to work with PyQt applications and UI files";
    homepage = "https://github.com/ColinDuquesnoy/pyqt_distutils";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.samw ];
  };
}
