{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  pytestCheckHook,
  stdlib-list,
  torch,
  torchvision,
}:

buildPythonPackage rec {
  pname = "fickling";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "fickling";
    tag = "v${version}";
    hash = "sha256-ExyjOTpIkDM2PmHxYUbe8xNhhQChqfUqTtsNR8Z7ZEk=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    stdlib-list
  ];

  pythonRelaxDeps = [ "stdlib-list" ];

  optional-dependencies = {
    torch = [
      numpy
      torch
      torchvision
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # https://github.com/trailofbits/fickling/issues/162
    # AttributeError: module 'numpy.lib.format' has no attribute...
    "test/test_polyglot.py"
  ];

  pythonImportsCheck = [ "fickling" ];

  meta = {
    description = "Python pickling decompiler and static analyzer";
    homepage = "https://github.com/trailofbits/fickling";
    changelog = "https://github.com/trailofbits/fickling/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
