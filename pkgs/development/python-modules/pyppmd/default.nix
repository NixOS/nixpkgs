{
  buildPythonPackage,
  fetchFromGitea,
  lib,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyppmd";
  version = "1.1.1";

  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "pyppmd";
    rev = "v${version}";
    hash = "sha256-0t1vyVMtmhb38C2teJ/Lq7dx4usm4Bzx+k7Zalf/nXE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  meta = {
    homepage = "https://codeberg.org/miurahr/pyppmd";
    description = "PPMd compression/decompression library";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
