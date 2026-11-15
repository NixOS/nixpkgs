{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "turnstone";
  version = "1.9.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ASnSDPd5aGCYg5X+vMnrN2huxkrRHe97G4g7eN9S6FM=";
  };

  nativeBuildInputs = [
    python3Packages.pythonRelaxDepsHook
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  # Temporary relaxations for older python package versions on this branch.
  # On nixpkgs master, these are already updated and this list can be pruned.
  pythonRelaxDeps = [
    "anthropic"
    "brotli"
    "croniter"
    "httpcore2"
    "httpx2"
    "mcp"
    "openai"
    "pydantic-settings"
    "starlette"
    "tzdata"
  ];

  dependencies = with python3Packages; [
    alembic
    altair
    anthropic
    bcrypt
    brotli
    croniter
    cryptography
    httpcore2
    httpx2
    jsonschema
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
    tzdata
    uvicorn
    vl-convert-python
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTestMarks = [
    "live"
    "e2e_recovery"
    "allow_thread_leak"
    "allow_lease_outside_slot"
  ];

  # Python 3.14 on Darwin crashes in libffi trampoline table allocation for ctypes/pypdfium2
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # Requires external network / live services
  ];

  pythonImportsCheck = [
    "turnstone"
  ];

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
