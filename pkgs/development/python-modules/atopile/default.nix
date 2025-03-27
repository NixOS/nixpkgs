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
  attrs,
  case-converter,
  cattrs,
  click,
  deepdiff,
  atopile-easyeda2ato,
  easyeda2ato,
  fake-useragent,
  fastapi,
  gitpython,
  igraph,
  jinja2,
  natsort,
  networkx,
  pandas,
  pint,
  pygls,
  quart-cors,
  quart-schema,
  quart,
  rich,
  ruamel-yaml,
  schema,
  scipy,
  semver,
  toolz,
  urllib3,
  uvicorn,
  watchfiles,
  pyyaml,
  black,
  cookiecutter,
  dataclasses-json,
  deprecated,
  freetype-py,
  kicadcliwrapper,
  matplotlib,
  more-itertools,
  pathvalidate,
  psutil,
  pydantic-settings,
  questionary,
  ruff,
  sexpdata,
  shapely,
  typer,
  pythonOlder,

  # tests
  pytestCheckHook,
  pytest-xdist,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "atopile";
  version = "0.3.20";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "atopile";
    tag = "v${version}";
    hash = "sha256-ejzTzSip/96eUNhBzGaLiOWs8l3SWBeDa9Ry6nkxCNw=";
  };

  build-system = [
    hatchling
    scikit-build-core
    hatch-vcs
    (nanobind.override { withCheck = false; })
  ];

  dontConfigure = true; # skip cmake configure invocation

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dependencies = [
    antlr4-python3-runtime
    attrs
    case-converter
    cattrs
    click
    deepdiff
    easyeda2ato
    # eseries
    fake-useragent
    fastapi
    gitpython
    igraph
    jinja2
    natsort
    networkx
    pandas
    pint
    pygls
    quart-cors
    quart-schema
    quart
    rich
    ruamel-yaml
    schema
    scipy
    semver
    toolz
    urllib3
    uvicorn
    watchfiles
    pyyaml # required for ato

    atopile-easyeda2ato
    black # used as a ddependency
    cookiecutter
    dataclasses-json
    deprecated
    freetype-py
    kicadcliwrapper
    matplotlib
    more-itertools
    pathvalidate
    psutil
    pydantic-settings
    questionary
    ruff
    sexpdata
    shapely
    typer
  ];

  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace-fail "scikit-build-core==0.9.2" "scikit-build-core>=0.9.2"
  '';

  pythonRelaxDeps = [
    "antlr4-python3-runtime"
    "black"
    "psutil"
  ];

  pythonImportsCheck = [ "atopile" ];

  preCheck = ''
    substituteInPlace test/conftest.py \
      --replace-fail "worker_id =" "worker_id = None #"

    substituteInPlace pyproject.toml \
      --replace-fail "--html=artifacts/test-report.html" "" \
      --replace-fail "--self-contained-html" "" \
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-timeout
  ];

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
