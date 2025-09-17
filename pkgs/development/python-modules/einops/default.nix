{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jupyter,
  nbconvert,
  numpy,
  parameterized,
  pillow,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  pythonOlder,
  torch,
}:

buildPythonPackage rec {
  pname = "einops";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arogozhnikov";
    repo = "einops";
    tag = "v${version}";
    hash = "sha256-J9m5LMOleHf2UziUbOtwf+DFpu/wBDcAyHUor4kqrR8=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    jupyter
    nbconvert
    numpy
    parameterized
    pillow
    pytestCheckHook
    torch
  ];

  env.EINOPS_TEST_BACKENDS = "numpy";

  pythonImportsCheck = [ "einops" ];

  disabledTestPaths = [
    # skip folder with notebook samples that depend on large packages
    # or accelerator access and have been unreliable
    "scripts/"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/arogozhnikov/einops/releases/tag/${src.tag}";
    description = "Flexible and powerful tensor operations for readable and reliable code";
    homepage = "https://github.com/arogozhnikov/einops";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
  };
}
