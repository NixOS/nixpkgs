{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "multivolumefile";
  version = "0.2.3";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oGSNCq+8luWRmNXBfprK1+tTGr6lEDXQjOgGDcrXCdY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  meta = {
    homepage = "https://codeberg.org/miurahr/multivolume";
    description = "Library to provide a file-object wrapping multiple files as virtually like as a single file";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
