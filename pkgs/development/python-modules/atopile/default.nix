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
  atopile-easyeda2ato,
  black,
  case-converter,
  cookiecutter,
  dataclasses-json,
  deprecated,
  fastapi-github-oidc,
  freetype-py,
  gitpython,
  kicadcliwrapper,
  matplotlib,
  more-itertools,
  natsort,
  numpy,
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
  pythonOlder,

  # tests
  pytestCheckHook,
  pytest-xdist,
  pytest-timeout,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "atopile";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "atopile";
    tag = "v${version}";
    hash = "sha256-DdHS4VynQzabKGcQZdgpTqiiT8HREwq5cEVoiQS4GzM=";
  };

  build-system = [
    hatchling
    scikit-build-core
    hatch-vcs
    nanobind
  ];

  dontConfigure = true; # skip cmake configure invocation

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dependencies = [
    antlr4-python3-runtime
    atopile-easyeda2ato
    black # used as a dependency
    case-converter
    cookiecutter
    dataclasses-json
    deprecated
    fastapi-github-oidc
    freetype-py
    gitpython
    kicadcliwrapper
    matplotlib
    more-itertools
    natsort
    numpy
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
  ];

  pythonRelaxDeps = [
    "black"
    "rich"
    "psutil"
  ];

  pythonImportsCheck = [ "atopile" ];

  preCheck = ''
    substituteInPlace test/conftest.py \
      --replace-fail "worker_id =" "worker_id = None #"

    substituteInPlace pyproject.toml \
      --replace-fail "--html=artifacts/test-report.html" "" \
      --replace-fail "--self-contained-html" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-timeout
    hypothesis
  ];

  doCheck = false; # test are hanging

  meta = {
    description = "Design circuit boards with code";
    homepage = "https://aiopg.readthedocs.io/";
    downloadPage = "https://github.com/atopile/atopile";
    changelog = "https://github.com/atopile/atopile/releases/tag/${src.rev}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "ato";
  };
}
