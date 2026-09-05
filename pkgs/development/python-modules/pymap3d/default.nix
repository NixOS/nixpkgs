{
  lib,
  astropy,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pyproj,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  xarray,
}:

let
  version = "3.2.0";
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
  pymap3d = buildPythonPackage {
    pname = "pymap3d";
    inherit version;
    pyproject = true;

    src = fetchFromGitHub {
      owner = "geospace-code";
      repo = "pymap3d";
      tag = "v${version}";
      hash = "sha256-5H2gPt986lfP5/rB4222vAqbvfsQQdQ736N+GBaDM90=";
    };

    build-system = [ setuptools ];

    inherit optional-dependencies;

    # tests missing an optional dependency skip themselves
    nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.core;

    pythonImportsCheck = [ "pymap3d" ];

    passthru.tests = {
      # the full suite minus the matlab-engine tests
      full = pymap3d.overridePythonAttrs (old: {
        nativeCheckInputs =
          old.nativeCheckInputs ++ optional-dependencies.full ++ optional-dependencies.proj;
      });
    };

    meta = {
      description = "Pure Python 3-D coordinate conversions for geodesy and astrometry";
      homepage = "https://github.com/geospace-code/pymap3d";
      changelog = "https://github.com/geospace-code/pymap3d/releases/tag/v${version}";
      license = lib.licenses.bsd2;
      maintainers = with lib.maintainers; [ jfr ];
    };
  };
in
pymap3d
