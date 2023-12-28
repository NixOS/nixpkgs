{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, deprecated
, rich
, backoff
, packaging
, pydantic
, typer
, tqdm
, wrapt
, numpy
, httpx
, pandas
, monotonic
# optional-dependencies
, fastapi
, opensearch-py
, elasticsearch8
, uvicorn
, smart-open
, brotli-asgi
, alembic
, sqlalchemy
, greenlet
, aiosqlite
, luqum
, scikit-learn
, aiofiles
, pyyaml
, python-multipart
, python-jose
, passlib
, psutil
# , segment-analytics-python
, asyncpg
, psycopg2
, schedule
, prodict
, cleanlab
, datasets
, huggingface-hub
# , flair
, faiss
, flyingsquid
, pgmpy
, plotly
, snorkel
, spacy
, transformers
, evaluate
, seqeval
# , setfit
# , span_marker
, openai
, peft
# test dependencies
, pytestCheckHook
, pytest-cov
, pytest-mock
, pytest-asyncio
, factory-boy
}:
let
  pname = "argilla";
  version = "1.21.0";
  optional-dependencies = {
    server = [
      fastapi
      opensearch-py
      elasticsearch8
      uvicorn
      smart-open
      brotli-asgi
      alembic
      sqlalchemy
      greenlet
      aiosqlite
      luqum
      scikit-learn
      aiofiles
      pyyaml
      python-multipart
      python-jose
      passlib
      psutil
      # segment-analytics-python
    ] ++
      elasticsearch8.optional-dependencies.async ++
      uvicorn.optional-dependencies.standard ++
      python-jose.optional-dependencies.cryptography ++
      passlib.optional-dependencies.bcrypt;
    postgresql = [ asyncpg psycopg2 ];
    listeners = [ schedule prodict ];
    integrations = [
      pyyaml
      cleanlab
      datasets
      huggingface-hub
      # flair
      faiss
      flyingsquid
      pgmpy
      plotly
      snorkel
      spacy
      transformers
      evaluate
      seqeval
      # setfit
      # span_marker
      openai
      peft
    ] ++ transformers.optional-dependencies.torch;
  };
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "argilla-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/CU/8CnoGhxe1tapA9k60o/Bpnaql/6Y/6Ksw5mfk/E=";
  };

  pythonRelaxDeps = [
    "typer"
    "rich"
    "numpy"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
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

  # still quite a bit of optional dependencies missing
  doCheck = false;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-mock
    pytest-asyncio
    factory-boy
  ]
    ++ optional-dependencies.server
    ++ optional-dependencies.postgresql
    ++ optional-dependencies.listeners
    ++ optional-dependencies.integrations;

  pytestFlagsArray = [ "--ignore=tests/server/datasets/test_dao.py" ];

  passthru.optional-dependencies = optional-dependencies;

  meta = with lib; {
    description = "Argilla: the open-source data curation platform for LLMs";
    homepage = "https://github.com/argilla-io/argilla";
    changelog = "https://github.com/argilla-io/argilla/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
