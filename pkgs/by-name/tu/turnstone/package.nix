{
  lib,
  python3Packages,
  fetchPypi,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "turnstone";
  version = "1.7.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+QKBufoklp4HgNdhFQ7mq0AoBN8P7xUXBjov/hK+LL0=";
  };

  nativeBuildInputs = [
    python3Packages.pythonRelaxDepsHook
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling>=1.29" "hatchling>=1.28"
  '';

  pythonRelaxDeps = [
    "anthropic"
    "cryptography"
    "mcp"
    "openai"
    "pydantic-settings"
    "starlette"
  ];

  dependencies = with python3Packages; [
    alembic
    altair
    anthropic
    bcrypt
    croniter
    cryptography
    httpx
    httpx-sse
    lacme
    mcp
    openai
    pillow
    psycopg
    pydantic
    pydantic-settings
    pyjwt
    pypdfium2
    python-frontmatter
    sqlalchemy
    sse-starlette
    starlette
    structlog
    uvicorn
    vl-convert-python
  ];

  doCheck = false; # tests require a running LLM backend

  passthru.tests = {
    inherit (nixosTests) turnstone;
  };

  meta = {
    description = "Self-hosted AI orchestration platform with tool use and agent routing";
    homepage = "https://github.com/turnstonelabs/turnstone";
    license = lib.licenses.asl20;
    mainProgram = "turnstone-server";
    maintainers = with lib.maintainers; [ timvherpen ];
  };
}
