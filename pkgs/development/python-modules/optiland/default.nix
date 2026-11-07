{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

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
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HarrisonKramer";
    repo = "optiland";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iyTvY+aqczzNCa13i/PnEiVAxXlqw9TWviqBANBV/sw=";
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
    # Flaky test according to the experience in:
    # https://github.com/NixOS/nixpkgs/pull/572833#issuecomment-6135335498
    "tests/test_materials.py::TestBaseMaterial::test_large_array_cache_key_avoids_python_scalar_overhead"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/optiland/optiland/issues/927
    "tests/regression/test_golden_snapshots.py::test_golden_snapshot[backend=numpy-wide_fov]"
    "tests/regression/test_golden_snapshots.py::test_golden_snapshot[backend=torch-wide_fov]"
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
