{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
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
# test dependencies
, pytestCheckHook
, fastapi
, sqlalchemy
, opensearch-py
, factory_boy
, elasticsearch8
, elastic-transport
, luqum
, pytest-asyncio
, passlib
, python-jose
, alembic
, uvicorn
, schedule
, prodict
, datasets
, psutil
, spacy
, cleanlab
, snorkel
, transformers
, faiss
}:
let
  pname = "argilla";
  version = "1.8.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "argilla-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pUfuwA/+fe1VVWyGxEkvSuJLNxw3sHmp8cQZecW8GWY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"rich <= 13.0.1"' '"rich"' \
      --replace '"numpy < 1.24.0"' '"numpy"'
  '';

  propagatedBuildInputs = [
    deprecated
    rich
    backoff
    packaging
    pydantic
    typer
    tqdm
    wrapt
    numpy
    pandas
    httpx
    monotonic
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # tests require an opensearch instance running and flyingsquid to be packaged
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    fastapi
    sqlalchemy
    opensearch-py
    factory_boy
    elasticsearch8
    elastic-transport
    luqum
    pytest-asyncio
    passlib
    python-jose
    alembic
    uvicorn
    schedule
    prodict
    datasets
    psutil
    spacy
    cleanlab
    snorkel
    transformers
    faiss
  ] ++ opensearch-py.optional-dependencies.async;

  pytestFlagsArray = [ "--ignore=tests/server/datasets/test_dao.py" ];

  meta = with lib; {
    description = "Argilla: the open-source data curation platform for LLMs";
    homepage = "https://github.com/argilla-io/argilla";
    changelog = "https://github.com/argilla-io/argilla/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
