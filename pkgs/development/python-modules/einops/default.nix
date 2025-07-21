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

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    jupyter
    nbconvert
    numpy
    parameterized
    pillow
    pytestCheckHook
    torch
  ];

  env.EINOPS_TEST_BACKENDS = "numpy";

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "einops" ];

  disabledTests = [
    # Tests are failing as mxnet is not pulled-in
    # https://github.com/NixOS/nixpkgs/issues/174872
    "test_all_notebooks"
    "test_dl_notebook_with_all_backends"
    "test_backends_installed"
    # depends on tensorflow, which is not available on Python 3.13
    "test_notebook_2_with_all_backends"
  ];

  disabledTestPaths = [ "einops/tests/test_layers.py" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/arogozhnikov/einops/releases/tag/${src.tag}";
    description = "Flexible and powerful tensor operations for readable and reliable code";
    homepage = "https://github.com/arogozhnikov/einops";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
  };
}
