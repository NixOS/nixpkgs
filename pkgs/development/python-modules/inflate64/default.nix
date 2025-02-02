{
  buildPythonPackage,
  fetchFromGitea,
  lib,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "inflate64";
  version = "1.0.1";

  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "inflate64";
    rev = "v${version}";
    hash = "sha256-deFx8NMbGLP51CdNvmZ25LQ5FLPBb1PB3QhGhIfTMfc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];
  nativeCheckInputs = [ pytestCheckHook ];
  meta = {
    homepage = "https://codeberg.org/miurahr/inflate64";
    description = "Compress and decompress with Enhanced Deflate compression algorithm";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };

}
