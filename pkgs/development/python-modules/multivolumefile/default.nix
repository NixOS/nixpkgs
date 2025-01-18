{
  buildPythonPackage,
  fetchFromGitea,
  lib,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "multivolumefile";
  version = "0.2.3";

  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "multivolume";
    rev = "v${version}";
    hash = "sha256-7gjfF7biQZOcph2dfwi2ouDn/uIYik/KBQ0k6u5Ne+Q=";
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
