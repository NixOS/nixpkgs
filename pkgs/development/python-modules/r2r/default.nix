{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonRelaxDepsHook,
  poetry-core,
  setuptools,
  pydantic,
  python-multipart,
  fastapi,
  fire,
  gunicorn,
  requests,
  types-requests,
  uvicorn,
  aiosqlite,
  asyncpg,
  redis,
  beautifulsoup4,
  openpyxl,
  markdown,
  pypdf,
  python-pptx,
  python-docx,
  nest-asyncio,
  tiktoken,
  sentence-transformers,
  vecs,
  pgvector,
  litellm,
  openai,
  dateutils,
  fsspec,
  posthog,
  sqlalchemy,
  ollama,
  neo4j,
  opencv4,
  moviepy,
  ingest-movies ? false,
}:

buildPythonPackage rec {
  pname = "r2r";
  version = "0.2.60";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SciPhi-AI";
    repo = "R2R";
    rev = "refs/tags/v${version}";
    hash = "sha256-Da1E+wUb1eAa8BhDnUpMSDVF/gexuPeYA19AOe9MjY8=";
  };

  build-system = [
    poetry-core
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "fastapi"
    "fire"
    "fsspec"
    "gunicorn"
    "ollama"
    "redis"
    "uvicorn"
  ];

  dependencies =
    [
      pydantic
      python-multipart

      fastapi
      fire
      gunicorn
      requests
      types-requests
      uvicorn

      aiosqlite
      asyncpg
      redis

      beautifulsoup4
      openpyxl
      markdown
      pypdf
      python-pptx
      python-docx
      nest-asyncio

      tiktoken
      sentence-transformers

      (vecs.override {
        pgvector = pgvector.overrideAttrs (oldAttrs: {
          # older version requied through setup.py
          version = "0.1.8";
          src = fetchFromGitHub {
            owner = "pgvector";
            repo = "pgvector-python";
            rev = "refs/tags/v0.1.8";
            sha256 = "sha256-+0daPPZGVkqfZw0gOZwIl+knL/zZki9fs5kA3dYqPpE=";
          };
          nativeCheckInputs = [ ];
        });
      })

      litellm
      openai

      dateutils
      fsspec
      posthog
      sqlalchemy
      ollama
      neo4j
    ]
    ++ lib.optionals ingest-movies [
      opencv4
      moviepy
    ];

  pythonImportsCheck = [ "r2r" ];

  meta = with lib; {
    description = "R2R was designed to bridge the gap between local LLM experimentation and scalable, production-ready Retrieval-Augmented Generation";
    homepage = "https://github.com/SciPhi-AI/R2R";
    changelog = "https://github.com/SciPhi-AI/R2R/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
