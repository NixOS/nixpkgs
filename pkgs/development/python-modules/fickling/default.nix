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

buildPythonPackage (finalAttrs: {
  pname = "fickling";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "fickling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p2XkHKqheVHqLTQKmUApiYH7NIaHc091B/TjiCDYWtA=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # https://github.com/trailofbits/fickling/issues/162
    # AttributeError: module 'numpy.lib.format' has no attribute...
    "test/test_polyglot.py"
  ];

  pythonImportsCheck = [ "fickling" ];

  meta = {
    description = "Python pickling decompiler and static analyzer";
    homepage = "https://github.com/trailofbits/fickling";
    changelog = "https://github.com/trailofbits/fickling/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
