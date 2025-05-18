{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  easyeda2ato,
  eseries,
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
  # tests
  pytestCheckHook,
  pytest-xdist,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "atopile";
  version = "0.2.69";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "atopile";
    tag = "v${version}";
    hash = "sha256-mQYnaWch0lVzz1hV6WboYxBGe3ruw+mK2AwMx13DQJM=";
  };

  build-system = [
    hatchling
    scikit-build-core
    hatch-vcs
    nanobind
  ];

  dependencies = [
    antlr4-python3-runtime
    attrs
    case-converter
    cattrs
    click
    deepdiff
    easyeda2ato
    eseries
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
  ];

  pythonRelaxDeps = [ "antlr4-python3-runtime" ];

  pythonImportsCheck = [ "atopile" ];

  preCheck = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--html=artifacts/test-report.html" "" \
      --replace-fail "--self-contained-html" ""
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
