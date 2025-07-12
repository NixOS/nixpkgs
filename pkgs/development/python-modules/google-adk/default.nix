{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonRelaxDepsHook,
  fetchFromGitHub,

  # build tools
  flit-core,
  setuptools,

  # dependencies
  authlib,
  click,
  fastapi,
  docstring-parser,
  google-api-core,
  google-api-python-client,
  google-auth,
  google-cloud-aiplatform,
  google-cloud-bigquery,
  google-cloud-resource-manager,
  google-cloud-secret-manager,
  google-cloud-speech,
  google-cloud-storage_2_19,
  google-genai,
  graphviz,
  mcp,
  opentelemetry-api,
  opentelemetry-exporter-gcp-trace,
  opentelemetry-sdk,
  protobuf,
  proto-plus,
  pydantic,
  python-dotenv,
  pyyaml,
  requests,
  shapely,
  sqlalchemy,
  starlette,
  typing-extensions,
  tzlocal,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "google-adk";
  version = "1.4.2";
  pyproject = true;

  build-system = [
    flit-core
    setuptools
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "adk-python";
    tag = "v${version}";
    hash = "sha256-IY+NJVEdn47UPuOM9KtVpnY4EtOJxaZ362qq9srlOzM=";
  };

  dependencies = [
    authlib
    click
    fastapi
    docstring-parser
    google-api-core
    google-api-python-client
    google-auth
    google-cloud-aiplatform
    google-cloud-bigquery
    google-cloud-resource-manager
    google-cloud-secret-manager
    google-cloud-speech
    google-cloud-storage_2_19
    google-genai
    graphviz
    mcp
    opentelemetry-api
    opentelemetry-exporter-gcp-trace
    opentelemetry-sdk
    protobuf
    proto-plus
    pydantic
    python-dotenv
    pyyaml
    requests
    shapely
    sqlalchemy
    starlette
    typing-extensions
    tzlocal
    uvicorn
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    # project.toml lists requests 2.32.4 as required.
    # But nixpkgs-master only has requests 2.32.3 at the time of writing.
    "requests"
  ];

  pythonImportsCheck = [ "google.adk" ];

  meta = {
    description = "An open-source, Python toolkit for building, evaluating, and deploying sophisticated AI agents.";
    homepage = "https://github.com/google/adk-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ RajwolChapagain ];
  };
}
