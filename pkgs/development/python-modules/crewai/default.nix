{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  gitUpdater,

  # build-system
  hatchling,

  # dependencies
  pydantic,
  langchain,
  openai,
  opentelemetry-api,
  opentelemetry-sdk,
  opentelemetry-exporter-otlp-proto-http,
  instructor,
  regex,
  crewai-tools,
  click,
  python-dotenv,
  appdirs,
  jsonref,
  json-repair,
  auth0-python,
  litellm,
  pyvis,
  uv,
  tomli-w,
  tomli,
  chromadb,

  # optionals
  agentops,
  mem0ai,
}:

buildPythonPackage rec {
  pname = "crewai";
  version = "0.80.0";

  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "crewAIInc";
    repo = "crewAI";
    rev = "refs/tags/${version}";
    hash = "sha256-MVWNjV2S2l96tEeaH+3sKftUVRDSkx0dLpfMbWsRRdc=";
  };

  dependencies = [
    pydantic
    langchain
    openai
    opentelemetry-api
    opentelemetry-sdk
    opentelemetry-exporter-otlp-proto-http
    instructor
    regex
    crewai-tools
    click
    python-dotenv
    appdirs
    jsonref
    json-repair
    auth0-python
    litellm
    pyvis
    uv
    tomli-w
    tomli
    chromadb
  ];

  optional-dependencies =
    let
      extras = {
        tools = [ crewai-tools ];
        agentops = [ agentops ];
        mem0 = [ mem0ai ];
      };
    in
    extras // { all = lib.concatLists (lib.attrValues extras); };

  pythonRelaxDeps = [
    "pyvis"
    "tomli"
    "tomli-w"
  ];

  build-system = [ hatchling ];

  enableParallelBuilding = true;

  doCheck = true;

  # This is for the import check.
  # Importing crewai needs a writable CREWAI_STORAGE_DIR.
  postInstall = ''
    export CREWAI_STORAGE_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "crewai" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    changelog = "https://github.com/crewAIInc/crewAI/releases";
    description = "Framework for orchestrating role-playing, autonomous AI agents.";
    downloadPage = "https://github.com/crewAIInc/crewAI/releases/tag/${version}";
    homepage = "https://www.crewai.com/";
    license = lib.licenses.mit;
    longDescription = ''
      Framework for orchestrating role-playing, autonomous AI agents.
      By fostering collaborative intelligence, CrewAI empowers agents
      to work together seamlessly, tackling complex tasks.
    '';
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
