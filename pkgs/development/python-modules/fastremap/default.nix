{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  pbr,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastremap";
  version = "1.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seung-lab";
    repo = "fastremap";
    tag = finalAttrs.version;
    hash = "sha256-0gHa3JSnHzutVFZ7czkJeFfBDqMjDy7501QBWsdKVyg=";
  };

  build-system = [
    cython
    numpy
    pbr
    setuptools
  ];

  dependencies = [ numpy ];

  env.PBR_VERSION = version;

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -r fastremap/
  '';

  pythonImportsCheck = [ "fastremap" ];

  meta = {
    description = "Remap, mask, renumber, unique, and in-place transposition of 3D labeled images and point clouds";
    homepage = "https://github.com/seung-lab/fastremap";
    changelog = "https://github.com/seung-lab/fastremap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
