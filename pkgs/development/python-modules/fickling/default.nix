{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  numpy,
  py7zr,
  pytestCheckHook,
  stdlib-list,
  torch,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "fickling";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "fickling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7wbQdInnKFnI76UNmF1/qwFO+2pFt9BXGPnrzHK8rYI=";
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
    py7zr
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # _pickle.UnpicklingError: pickle exhausted before end of frame
    "test_insert"
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
