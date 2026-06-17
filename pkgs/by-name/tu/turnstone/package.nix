{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "turnstone";
  version = "1.6.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1axaic8053xh1a0fya0y24f8knrwxx2lz6pnqk570cb071pcr4dm";
  };

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
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
    "starlette"
  ];

  dependencies = with python3Packages; [
    alembic
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
  ];

  doCheck = false;

  meta = {
    description = "Self-hosted AI orchestration platform with tool use and agent routing";
    homepage = "https://github.com/turnstonelabs/turnstone";
    license = lib.licenses.asl20;
    mainProgram = "turnstone-server";
    maintainers = [ ];
  };
}
