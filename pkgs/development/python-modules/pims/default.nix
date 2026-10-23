{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  imageio,
  numpy,
  pytestCheckHook,
  scikit-image,
  slicerator,
  packaging,
  tifffile,
  jinja2,
  jpype1,
  matplotlib,
  moviepy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pims";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = "pims";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3SBZk11w6eTZFmETMRJaYncxY38CYne1KzoF5oRgzuY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    slicerator
    imageio
    numpy
    packaging
    tifffile # imported within try-excet block so optional but setup.py requires it.
  ];

  optional-dependencies = {
    # CI says its extras
    extras = [
      jinja2
      jpype1
      matplotlib
      moviepy
      scikit-image
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.extras;

  pythonImportsCheck = [ "pims" ];

  pytestFlags = [
    "-Wignore::Warning"
  ];

  disabledTests = [
    # NotImplementedError: Do not know how to deal with infinite readers
    "TestVideo_ImageIO"
  ];

  disabledTestPaths = [
    # AssertionError: Tuples differ: (377, 505, 4) != (384, 512, 4)
    "pims/tests/test_display.py"

    # tests require internet connection
    "pims/tests/test_bioformats.py"
  ];

  meta = {
    description = "Module to load video and sequential images in various formats";
    homepage = "https://github.com/soft-matter/pims";
    changelog = "https://github.com/soft-matter/pims/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
