{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  cython,

  # dependencies
  pymatgen-core,
}:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2026.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "materialsproject";
    repo = "pymatgen";
    tag = "v${version}";
    hash = "sha256-BT50dhPI5/g3/a6jwLen5uOcpTTAfzAzlo5erUnqnZ8=";
  };

  build-system = [
    setuptools
    cython
  ];

  dependencies = [ pymatgen-core ];

  pythonImportsCheck = [ "pymatgen" ];

  meta = {
    description = "Robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    changelog = "https://github.com/materialsproject/pymatgen/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
