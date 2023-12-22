{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python
, pydantic
, dataclasses-json
, httpx
, openai
, langchain
, tiktoken
, typing-extensions
, typing-inspect
, requests
, asyncpg
, pgvector
# , psycopg-binary
, optimum
, sentencepiece
, guidance
# , lm-format-enforcer
, jsonpath-ng
, rank-bm25
, scikit-learn
, spacy
, deprecated
, tenacity
, numpy
, beautifulsoup4
, pandas
, fsspec
, nest-asyncio
, sqlalchemy
, transformers
, torch
, nltk
, aiostream
, aiohttp
}:

buildPythonPackage rec {
  pname = "llama-index";
  version = "0.9.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "llama_index";
    rev = "refs/tags/v${version}";
    hash = "sha256-sXG9yhls3zPHGYCSCJMDp4T02O4kCDp7pr40aWEplt8=";
  };

  nativeBuildInputs = [ python.pkgs.poetry-core ];

  # TODO enable tests with pytestCheckHook and pythonImportsCheck.
https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md#testing-python-packages-testing-python-packages

  propagatedBuildInputs = [
    sqlalchemy
    beautifulsoup4
    dataclasses-json
    deprecated
    fsspec
    httpx
    langchain # optional
    nest-asyncio
    nltk
    numpy
    openai
    pandas
    python
    tenacity
    tiktoken
    typing-extensions
    typing-inspect
    requests
    asyncpg # optional
    pgvector # optional
    # psycopg-binary # not in nixpkgs yet
    optimum # optional
    sentencepiece # optional
    transformers # optional
    guidance # optional
    # lm-format-enforcer # not in nixpkgs yet
    jsonpath-ng # optional
    rank-bm25 # optional
    scikit-learn # optional
    spacy # optional
    aiostream
    aiohttp

  ];

  meta = with lib; {
    description = "Interface between LLMs and your data";
    homepage = "https://github.com/run-llama/llama_index";
    license = licenses.mit;
    maintainers = with maintainers; [ paretoOptimalDev ];
  };

}

