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
  pythonRelaxDepsHook,
  pyyaml,
  rich,
  schedule,
  scikit-learn,
  sentence-transformers,
  seqeval,
  setuptools,
  smart-open,
  snorkel,
  spacy,
  spacy-transformers,
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
  version = "1.28.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "argilla-io";
    repo = "argilla";
    rev = "refs/tags/v${version}";
    hash = "sha256-gQpJ2umi3IE5BhRu3bM7ONPIP0hb2YG37jGvDKQHZWA=";
  };

  pythonRelaxDeps = [
    "httpx"
    "numpy"
    "rich"
    "typer"
    "wrapt"
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
