{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  versioningit,

  # dependencies
  matplotlib,
  numba,
  numpy,
  pandas,
  pyyaml,
  requests,
  scipy,
  seaborn,
  tabulate,
  typing-extensions,
  vtk,

  # tests
  pytestCheckHook,
  pytest-xdist,
  writableTmpDirAsHomeHook,

  # optional-dependencies
  pyside6,
  qtconsole,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "optiland";
  version = "0.6.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HarrisonKramer";
    repo = "optiland";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4A58AdEDVvHtG3ZS67Ycpd+kRKt69BLEtPMaIGR1dvI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'default-version = "0.0.0+unknown"' \
        'default-version = "${finalAttrs.version}"'
  '';

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [
    matplotlib
    numba
    numpy
    pandas
    pyyaml
    requests
    scipy
    seaborn
    tabulate
    typing-extensions
    vtk
  ];

  passthru = {
    optional-dependencies = {
      gui = [
        pyside6
        qtconsole
      ];
      torch = [
        torch
      ];
    };
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    writableTmpDirAsHomeHook
  ]
  # No need for optional-dependencies.gui, as the relevant tests requiring the
  # gui dependencies are disabled below.
  ++ finalAttrs.finalPackage.passthru.optional-dependencies.torch;

  disabledTestPaths = [
    # From some reason, importing pyside6 during tests causes a core dump of the
    # python interpreter, so we disable all GUI tests.
    "tests/gui/"
    # All of these 5 fail similarly, see:
    # https://github.com/optiland/optiland/issues/746
    "tests/test_ray_aiming.py::test_epd_invariant_under_translation[backend=numpy-25.0-issue613"
    "tests/test_ray_aiming.py::test_epd_invariant_under_translation[backend=numpy--15.0-issue613"
    "tests/test_ray_aiming.py::test_float_by_stop_epd_invariant_under_translation[backend=numpy-30.0"
    "tests/test_ray_aiming.py::test_float_by_stop_epd_invariant_under_translation[backend=numpy--10.0"
    "tests/test_ray_aiming.py::test_float_by_stop_epd_invariant_under_translation[backend=numpy-1000.0"
  ];

  pythonImportsCheck = [
    "optiland"
  ];

  meta = {
    description = "Comprehensive optical design, optimization, and analysis in Python, including GPU-accelerated and differentiable ray tracing via PyTorch";
    homepage = "https://github.com/HarrisonKramer/optiland";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    # Intentionally not setting optiland meta.mainProgram, as it is not
    # functional without additional qt6 and python libraries available. See
    # pkgs/by-name/op/optiland/package.nix for a derivation with a working GUI.
  };
})
