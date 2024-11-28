{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  gitUpdater,

  # build-system
  poetry-core,

  # propagates
  qdrant-client,
  pydantic,
  openai,
  posthog,
  pytz,
  sqlalchemy,

  # runtime dependencies
  langchain-community,
  neo4j,
  rank-bm25,
}:

buildPythonPackage rec {
  pname = "mem0ai";
  version = "0.1.123";

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mem0ai";
    repo = "mem0";
    rev = "refs/tags/${version}";
    hash = "sha256-/+A2w1HWq2toZOyCMd580p/Nd0rXs1w2eDD5Y3t3nP4=";
  };

  dependencies = [
    qdrant-client
    pydantic
    openai
    posthog
    pytz
    sqlalchemy
    langchain-community
    neo4j
    rank-bm25
  ];

  pythonRelaxDeps = [
    "langchain-community"
  ];

  build-system = [ poetry-core ];

  enableParallelBuilding = true;

  doCheck = true;

  # This is for the import check.
  # Importing mem0 needs a writeable MEM0_DIR
  postInstall = ''
    export MEM0_DIR=$(mktemp -d)
  '';

  # Import check currently fails when mem0 tries to make a directory in nix's read-only fs.
  # TODO: set MEM0_DIR env variable before this check; have tried but so far unsuccessful
  pythonImportsCheck = [ "mem0" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Mem0 enhances AI assistants and agents with an intelligent memory layer.";
    downloadPage = "https://github.com/mem0ai/mem0/releases/tag/${version}";
    homepage = "https://mem0.ai/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
