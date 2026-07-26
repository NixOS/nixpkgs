{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  hatchling,

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

  # optional-dependencies
  pyside6,
  qtconsole,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "optiland";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HarrisonKramer";
    repo = "optiland";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s+EFsfj+3VIgpqhBv8f6IblyxfxXHWnO/i1lO3bEke4=";
  };

  patches = [
    # wayland is not supported, see:
    # https://github.com/optiland/optiland/issues/556
    (fetchpatch {
      url = "https://github.com/optiland/optiland/commit/9644df6e06bd24c5a3a7cf36c8df9dd83050bccc.patch";
      hash = "sha256-a74Z7rp3ji3+9lM8Q/RttMIzwlRBki1N2Y0YtBiVaEA=";
    })
    # A fixup for the above, see:
    #
    # - https://github.com/optiland/optiland/pull/564#discussion_r3106831922
    # - https://github.com/optiland/optiland/pull/568
    (fetchpatch {
      url = "https://github.com/optiland/optiland/commit/652922bce5e1854f1d067e292422d95dee129a46.patch";
      hash = "sha256-9O+DNbqBDDSAaRkwCy3o76lwy5MJ7WHQqzfcN1fcmnE=";
    })
  ];

  build-system = [
    hatchling
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
  ]
  # No need for optional-dependencies.gui, as the relevant tests requiring the
  # gui dependencies are disabled below.
  ++ finalAttrs.finalPackage.passthru.optional-dependencies.torch;

  disabledTestPaths = [
    # From some reason, importing pyside6 during tests causes a core dump of the
    # python interpreter, so we disable all GUI tests.
    "tests/gui/"
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
