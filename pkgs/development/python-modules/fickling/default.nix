{
  lib,
  astunparse,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  flit-core,
  numpy,
  pytestCheckHook,
  torch,
  torchvision,
  stdlib-list,
}:

buildPythonPackage rec {
  pname = "fickling";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "fickling";
    tag = "v${version}";
    hash = "sha256-EgVtMYPwSVBlw1bmX3qEeUKvEY7Awv6DOB5tgSLG+xQ=";
  };

  build-system = [
    distutils
    flit-core
  ];

  dependencies = [
    astunparse
    stdlib-list
  ];

  pythonRelaxDeps = [ "stdlib_list" ];

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
