{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pytorch-lightning,

  # tests
  psutil,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "lightning";
  pyproject = true;

  inherit (pytorch-lightning)
    version
    src
    build-system
    meta
    ;

  dependencies = pytorch-lightning.dependencies ++ [ pytorch-lightning ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  doCheck = false;

  pythonImportsCheck = [
    "lightning"
    "lightning.pytorch"
  ];
}
