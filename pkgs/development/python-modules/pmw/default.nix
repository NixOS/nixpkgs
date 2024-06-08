{
  lib,
  buildPythonPackage,
  fetchPypi,
  tkinter,
}:

buildPythonPackage rec {
  pname = "pmw";
  version = "2.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "Pmw";
    inherit version;
    hash = "sha256-lIQSRXz8zwx3XdCOCRP7APkIlqM8eXN9VxxzEq6vVcY=";
  };

  propagatedBuildInputs = [ tkinter ];

  # Disable tests due to their xserver requirement
  doCheck = false;

  meta = {
    description = "A toolkit for building high-level compound widgets in Python using the Tkinter module";
    homepage = "https://pmw.sourceforge.net/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mounium ];
  };
}
