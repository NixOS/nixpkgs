{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  ninja,
  scikit-build-core,

  # nativeBuildInputs
  cmake,

  # dependencies
  torch,

  # tests
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "deepwave";
  version = "0.0.27";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ar4";
    repo = "deepwave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zOyoycCJjx4HJEnkAD5r7d+qxO5A+d0dCgx2oRjxPuU=";
  };

  build-system = [
    ninja
    scikit-build-core
  ];

  nativeBuildInputs = [
    cmake
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [ "deepwave" ];

  meta = {
    description = "Wave propagation modules for PyTorch";
    homepage = "https://github.com/ar4/deepwave";
    license = lib.licenses.mit;
    platforms = lib.intersectLists lib.platforms.x86_64 lib.platforms.linux;
    maintainers = [ ];
  };
})
