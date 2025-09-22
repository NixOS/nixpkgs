{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  cmake,
  ninja,
  # build-system
  hatchling,
  scikit-build-core,
  hatch-vcs,
  nanobind,
  # deps
  antlr4-python3-runtime,
  atopile-easyeda2kicad,
  black,
  case-converter,
  cookiecutter,
  dataclasses-json,
  deprecated,
  fastapi-github-oidc,
  freetype-py,
  gitpython,
  kicad-python,
  kicadcliwrapper,
  matplotlib,
  mcp,
  more-itertools,
  natsort,
  numpy,
  ordered-set,
  pathvalidate,
  pint,
  posthog,
  psutil,
  pydantic-settings,
  pygls,
  questionary,
  requests,
  rich,
  ruamel-yaml,
  ruff,
  semver,
  sexpdata,
  shapely,
  typer,
  urllib3,
  zstd,
  pythonOlder,

  # tests
  pytestCheckHook,

  pytest-benchmark,
  pytest-timeout,
  pytest-datafiles,
  pytest-xdist,
  hypothesis,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "atopile";
  version = "0.11.2";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "atopile";
    tag = "v${version}";
    hash = "sha256-JczlQulHlViV9pg0uPXd9Boagp74VBdZ1UMDXh2c3DA=";
  };

  build-system = [
    hatchling
    scikit-build-core
    hatch-vcs
    nanobind
  ];

  dontUseCmakeConfigure = true; # skip cmake configure invocation

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dependencies = [
    antlr4-python3-runtime
    atopile-easyeda2kicad
    black # used as a dependency
    case-converter
    cookiecutter
    dataclasses-json
    deprecated
    fastapi-github-oidc
    freetype-py
    gitpython
    kicad-python
    kicadcliwrapper
    matplotlib
    mcp
    more-itertools
    natsort
    numpy
    ordered-set
    pathvalidate
    pint
    posthog
    psutil
    pydantic-settings
    pygls
    questionary
    requests
    rich
    ruamel-yaml
    ruff
    semver
    sexpdata
    shapely
    typer
    urllib3
    zstd
  ];

  pythonRelaxDeps = [
    "posthog"
    "zstd"
  ];

  pythonImportsCheck = [ "atopile" ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-xdist
    pytest-benchmark
    pytest-datafiles
    pytest-timeout
    hypothesis
  ];

  preCheck = ''
    # do not report worker logs to filee
    substituteInPlace test/conftest.py \
      --replace-fail "worker_id =" "worker_id = None #"

    # unrecognized flags
    substituteInPlace pyproject.toml \
      --replace-fail "--html=artifacts/test-report.html" "" \
      --replace-fail "--self-contained-html" "" \
      --replace-fail "--numprocesses=auto" "" \

    # Replace this function call that cause test to hang
    substituteInPlace            \
      test/cli/test_packages.py  \
      test/library/test_names.py \
      test/test_examples.py      \
      test/test_parse_utils.py   \
        --replace-fail "_repo_root()" "Path('$(pwd)')"

    # Fix crash due to empty list in fixture tests
    substituteInPlace            \
      test/test_examples.py      \
      test/test_parse_utils.py   \
        --replace-fail "p.stem" "p.stem if isinstance(p, Path) else p"
  '';

  disabledTestPaths = [
    # timouts
    "test/test_cli.py"
    "test/cli/test_packages.py"
    "test/end_to_end/test_net_naming.py"
    "test/end_to_end/test_pcb_export.py"
    "test/exporters/bom/test_bom.py"
    "test/front_end/test_front_end_pick.py"
    "test/libs/picker/test_pickers.py"
  ];

  disabledTests = [
    # timeout
    "test_build_error_logging"
    "test_performance_mifs_bus_params"
    "test_resistor"
    "test_reserved_attrs"
    # requires internet
    "test_simple_pick"
    "test_simple_negative_pick"
    "test_jlcpcb_pick_resistor"
    "test_jlcpcb_pick_capacitor"
    "test_regression_rp2040_usb_diffpair_full"
    "test_model_translations"
    # type error
    "test_alternate_trait_constructor_with_params"
    "test_parameterised_trait_with_params"
    "test_trait_alternate_constructor_precedence"
    "test_trait_template_enum"
    "test_trait_template_enum_invalid"
    # failure
    "test_solve_voltage_divider_complex"
  ];

  # in order to use pytest marker, we need to use ppytestFlagsArray
  # using pytestFlags causes `ERROR: file or directory not found: slow`
  pytestFlagsArray = [
    "-m='not slow and not not_in_ci and not regression'"
    "--timeout=10" # any test taking long, timouts with more than 60s
    "--benchmark-disable"
    "--tb=line"
  ];

  doCheck = true;

  meta = {
    description = "Design circuit boards with code";
    homepage = "https://atopile.io";
    downloadPage = "https://github.com/atopile/atopile";
    changelog = "https://github.com/atopile/atopile/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "ato";
  };
}
