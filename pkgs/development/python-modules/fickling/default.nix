{
  lib,
<<<<<<< HEAD
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  pytestCheckHook,
  stdlib-list,
  torch,
  torchvision,
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "fickling";
<<<<<<< HEAD
  version = "0.1.6";
=======
  version = "0.1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "fickling";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-p2XkHKqheVHqLTQKmUApiYH7NIaHc091B/TjiCDYWtA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    stdlib-list
  ];

  pythonRelaxDeps = [ "stdlib-list" ];
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  optional-dependencies = {
    torch = [
      numpy
      torch
      torchvision
    ];
  };

<<<<<<< HEAD
  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;
=======
  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ sarahec ];
=======
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
