{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  numpy,
  pytestCheckHook,
  stdlib-list,
  torch,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "fickling";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "fickling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uirVOJ6CI7gBu9lOoPtpjUZeBmIhBMI0tjSDI/ASy7w=";
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

  # Tests fail upstream in pytorch under python 3.14
  doCheck = pythonOlder "3.14";

  pythonImportsCheck = [ "fickling" ];

  meta = {
    description = "Python pickling decompiler and static analyzer";
    homepage = "https://github.com/trailofbits/fickling";
    changelog = "https://github.com/trailofbits/fickling/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
