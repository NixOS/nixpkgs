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
  version = "1.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seung-lab";
    repo = "fastremap";
    tag = version;
    hash = "sha256-naDagGD0VNRjoJ1+gkgLm3QbrnE9hD85ULz91xAfKa4=";
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
    changelog = "https://github.com/seung-lab/fastremap/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
