{
  lib,
  aiofiles,
  aiosqlite,
  alembic,
  asyncpg,
  backoff,
  brotli-asgi,
  buildPythonPackage,
  cleanlab,
  datasets,
  deprecated,
  elasticsearch8,
  evaluate,
  factory-boy,
  faiss,
  fastapi,
  fetchFromGitHub,
  flyingsquid,
  greenlet,
  httpx,
  huggingface-hub,
  luqum,
  monotonic,
  numpy,
  openai,
  opensearch-py,
  packaging,
  pandas,
  passlib,
  setuptools,
  peft,
  pgmpy,
  plotly,
  prodict,
  psutil,
  psycopg2,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-jose,
  python-multipart,
  pythonOlder,
  pyyaml,
  rich,
  schedule,
  scikit-learn,
  sentence-transformers,
  seqeval,
  smart-open,
  snorkel,
  spacy-transformers,
  spacy,
  sqlalchemy,
  tqdm,
  transformers,
  typer,
  uvicorn,
  wrapt,
# , flair
# , setfit
# , spacy-huggingface-hub
# , span_marker
# , trl
}:

buildPythonPackage rec {
  pname = "argilla";
  version = "1.29.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "argilla-io";
    repo = "argilla";
    rev = "refs/tags/v${version}";
    hash = "sha256-ndendXlgACFdwnZ/P2W22Tr/Ji8AYw/6jtb8F3/zqSA=";
  };

  sourceRoot = "${src.name}/${pname}";

  pythonRelaxDeps = [
    "httpx"
    "numpy"
    "rich"
    "typer"
    "wrapt"
  ];

  build-system = [ setuptools ];

  dependencies = [
    httpx
    deprecated
    packaging
    pandas
    pydantic
    wrapt
    numpy
    tqdm
    backoff
    monotonic
    rich
    typer
  ];

  optional-dependencies = {
    server =
      [
        aiofiles
        aiosqlite
        alembic
        brotli-asgi
        elasticsearch8
        fastapi
        greenlet
        luqum
        opensearch-py
        passlib
        psutil
        python-jose
        python-multipart
        pyyaml
        scikit-learn
        smart-open
        sqlalchemy
        uvicorn
      ]
      ++ elasticsearch8.optional-dependencies.async
      ++ uvicorn.optional-dependencies.standard
      ++ python-jose.optional-dependencies.cryptography
      ++ passlib.optional-dependencies.bcrypt;
    postgresql = [
      asyncpg
      psycopg2
    ];
    listeners = [
      schedule
      prodict
    ];
    integrations = [
      cleanlab
      datasets
      evaluate
      faiss
      flyingsquid
      huggingface-hub
      openai
      peft
      pgmpy
      plotly
      pyyaml
      sentence-transformers
      seqeval
      snorkel
      spacy
      spacy-transformers
      transformers
      # flair
      # setfit
      # span_marker
      # trl
      # spacy-huggingface-hub
    ] ++ transformers.optional-dependencies.torch;
  };

  # Still quite a bit of optional dependencies missing
  doCheck = false;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-asyncio
    factory-boy
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTestPaths = [ "tests/server/datasets/test_dao.py" ];

  meta = with lib; {
    description = "Open-source data curation platform for LLMs";
    homepage = "https://github.com/argilla-io/argilla";
    changelog = "https://github.com/argilla-io/argilla/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "argilla";
  };
}
