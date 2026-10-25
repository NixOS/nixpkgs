{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  kicad,

  # build-time
  cmake,
  ninja,
  pkg-config,
  python,

  # run-time
  boost,
  gmp,
  mpfr,

  # build-system
  nanobind,
  scikit-build-core,
  setuptools,
  setuptools-scm,
  wheel,

  # dependencies
  lxml,
  numpy,
  pygerber,
  pyopengl,
  pyside6,
  scipy,
  sexpdata,
  shapely,

  # tests
  pytestCheckHook,
  typeguard,
}:

buildPythonPackage (finalAttrs: {
  pname = "padne";
  version = "0.3";
  pyproject = true;
  dontUseCmakeConfigure = true; # handled by python
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "atx";
    repo = "padne";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eFrBjmLZQnfMG7nl9gHPb0Qr8MCAdhjzRIp5n1IzguM=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # `padne` tries to import `pcbnew` directly from `KiCad`, falling back to
    # `kigadgets` if that fails.
    # However, `kigadgets` only supports KiCad v5-v9, whereas Nixpkgs is on
    # v10, so drop it as a dependency to avoid a broken fallback.
    sed -i '/kigadgets/d' pyproject.toml
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    gmp
    mpfr
    nanobind
  ];

  cmakeFlags = [
    (lib.cmakeFeature "nanobind_DIR" "${nanobind}/${python.sitePackages}/nanobind/cmake")
  ];

  build-system = [
    nanobind
    scikit-build-core
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    kicad
    lxml
    numpy
    finalAttrs.passthru.pygerber
    pyopengl
    pyside6
    scipy
    sexpdata
    shapely
  ];

  pythonImportsCheck = [
    "padne"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    typeguard
  ];

  preCheck = ''
    # remove src module, so tests use the installed module, instead
    mv padne _padne
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isAarch64 [
    # AssertionError: Center distance 4.8999999999999995 not ~5.0
    "test_basic_rectangle_distance_map"
  ];

  passthru = {
    # Padne needs a more recent version of `pygerber` than the one in Nixpkgs,
    # which is currently the 2.4.3 stable release.
    pygerber = pygerber.overrideAttrs {
      version = "2.4.3-unstable-2026-03-20";
      src = fetchFromGitHub {
        owner = "Argmaster";
        repo = "pygerber";
        rev = "5446d44d424897e1b1a68c48c160ed9b4e828f44";
        hash = "sha256-AhLIBh1dAmmOLBw6XaJIeYhUAh1BSv/ALVc4qOfD7g4=";
      };
      # TODO:
      # 46 failed, 592 passed, 1 xfailed, 61 warnings, 96 errors in 16.52s
      dontUsePytestCheck = true;
    };
  };

  meta = {
    description = "KiCad-focused Power Delivery Network Simulator";
    longDescription = ''
      Padne is a KiCad-native power delivery network analysis tool.

      It uses the finite element method in order to simulate the voltage drop
      induced by DC currents on printed circuit boards.

      This allows easy identification of resistive bottlenecks, design of high
      current distribution networks or implementing complex heating elements.
    '';
    homepage = "https://github.com/atx/padne";
    changelog = "https://github.com/atx/padne/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "padne";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
