{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  stdenv,
  torch,
  torch-einops-utils,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyper-connections";
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "hyper-connections";
    tag = finalAttrs.version;
    hash = "sha256-RDwnRtHUWilyqsDmdiV+kRg7BqTS1yghiu9RAM+MNjE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    einops
    torch
    torch-einops-utils
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # torch's cpuinfo init fails to parse /sys/devices/system/cpu/{possible,present}
    # in the build sandbox on aarch64-linux, breaking `.half()` calls
    "test_mhc_dtype_restoration"
  ];

  pythonImportsCheck = [ "hyper_connections" ];

  meta = {
    description = "Module to make multiple residual streams";
    homepage = "https://github.com/lucidrains/hyper-connections";
    changelog = "https://github.com/lucidrains/hyper-connections/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
