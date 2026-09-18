{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  embree,
  cython,
  numpy,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "embreex";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trimesh";
    repo = "embreex";
    tag = version;
    hash = "sha256-mUPc9CMHsFYb1ELBmj+XXCjYEIW1iV8ZaRCQ40tYS8w=";
  };

  build-system = [
    setuptools
    numpy
    cython
  ];

  dependencies = [
    numpy
  ];

  buildInputs = [
    embree
  ];

  pythonImportsCheck = [
    "embreex"
    "embreex.mesh_construction"
    "embreex.rtcore"
    "embreex.rtcore_scene"
  ];

  preCheck = ''
    # conflicts with $out
    rm -rf embreex/
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Maintained PyEmbree fork, bindings for Intel's Embree ray engine";
    homepage = "https://github.com/trimesh/embreex";
    changelog = "https://github.com/trimesh/embreex/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pbsds ];
    inherit (embree.meta) platforms;
  };
}
