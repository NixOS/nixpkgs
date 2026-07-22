{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # tests
  setuptools,

  # dependencies
  pyvers,
  torch,

  # tests
  llvmPackages,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hoptorch";
  version = "0.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vmoens";
    repo = "hoptorch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rhX81MidgltQ2YQtUdYoK1Qtz7N7x9MpZIKDlZzN+vg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyvers
    torch
  ];

  pythonImportsCheck = [ "hoptorch" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Small compatibility package for PyTorch higher-order operators";
    homepage = "https://github.com/vmoens/hoptorch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
