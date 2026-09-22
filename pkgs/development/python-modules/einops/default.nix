{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # tests
  jupyter,
  nbconvert,
  numpy,
  parameterized,
  pillow,
  pytestCheckHook,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "einops";
  version = "0.8.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "arogozhnikov";
    repo = "einops";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d5Vbtkw/MChS2j2IC6j97wfVoKWZT9mU4OeXyEjm6ys=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    jupyter
    nbconvert
    numpy
    parameterized
    pillow
    pytestCheckHook
    torch
    writableTmpDirAsHomeHook
  ];

  env.EINOPS_TEST_BACKENDS = "numpy";

  pythonImportsCheck = [ "einops" ];

  disabledTestPaths = [
    # skip folder with notebook samples that depend on large packages
    # or accelerator access and have been unreliable
    "scripts/"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Flexible and powerful tensor operations for readable and reliable code";
    homepage = "https://github.com/arogozhnikov/einops";
    changelog = "https://github.com/arogozhnikov/einops/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
})
