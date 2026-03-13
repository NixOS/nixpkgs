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

buildPythonPackage rec {
  pname = "fastremap";
  version = "1.17.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seung-lab";
    repo = "fastremap";
    tag = version;
    hash = "sha256-k3MneLLpClx0hkOqm+botD/LozyoUJW89qf0VJ3P05M=";
  };

  build-system = [
    cython
    numpy
    pbr
    setuptools
  ];

  dependencies = [
    numpy
  ];

  env.PBR_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fastremap"
  ];

  meta = {
    description = "Remap, mask, renumber, unique, and in-place transposition of 3D labeled images and point clouds";
    homepage = "https://github.com/seung-lab/fastremap";
    changelog = "https://github.com/seung-lab/fastremap/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
