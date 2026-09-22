{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # optional-dependencies
  # core:
  numpy,
  python-dateutil,
  # full:
  astropy,
  xarray,
  # proj:
  pyproj,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymap3d";
  version = "3.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "geospace-code";
    repo = "pymap3d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5H2gPt986lfP5/rB4222vAqbvfsQQdQ736N+GBaDM90=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    core = [
      numpy
      python-dateutil
    ];
    full = [
      astropy
      xarray
    ];
    proj = [ pyproj ];
  };

  # tests missing an optional dependency skip themselves
  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.core;

  pythonImportsCheck = [ "pymap3d" ];

  passthru.tests = {
    # the full suite minus the matlab-engine tests
    full = finalAttrs.finalPackage.overrideAttrs (old: {
      nativeInstallCheckInputs =
        old.nativeInstallCheckInputs
        ++ finalAttrs.passthru.optional-dependencies.full
        ++ finalAttrs.passthru.optional-dependencies.proj;
    });
  };

  meta = {
    description = "Pure Python 3-D coordinate conversions for geodesy and astrometry";
    homepage = "https://github.com/geospace-code/pymap3d";
    changelog = "https://github.com/geospace-code/pymap3d/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jfr ];
  };
})
