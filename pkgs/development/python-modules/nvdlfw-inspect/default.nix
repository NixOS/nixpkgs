{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  pyyaml,
  torch,

  # tests
  pytestCheckHook,
}:

# nixpkgs-update: no auto update
# The bot tries to update the package to the older 0.2 tag

buildPythonPackage (finalAttrs: {
  pname = "nvdlfw-inspect";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-dlfw-inspect";
    # No tag, found the commit using `git blame`
    rev = "3a7314ac44f8479a3368a69ac4c7938e40e6104c";
    hash = "sha256-qLyPzdwIIXHUDeP226w4yo2B1fqOKZ3yeSXrG3pNQyk=";
  };

  dependencies = [
    pyyaml
    torch
  ];

  pythonImportsCheck = [ "nvdlfw_inspect" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Facilitates debugging convergence issues and testing new algorithms/recipes for training LLMs using Nvidia libraries";
    homepage = "https://github.com/NVIDIA/nvidia-dlfw-inspect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
