{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python
, pydantic
, dataclasses-json
, httpx
, openai
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
}:

buildPythonPackage rec {
  pname = "llama-index";
  version = "0.9.13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "llama_index";
    rev = "refs/tags/v${version}";
    hash = "sha256-sXG9yhls3zPHGYCSCJMDp4T02O4kCDp7pr40aWEplt8=";
  };

  nativeBuildInputs = [ python.pkgs.poetry-core ];

  propagatedBuildInputs = [
    pydantic
    dataclasses-json
    httpx
    openai
    deprecated
    tenacity
    numpy
    beautifulsoup4
    pandas
    fsspec
    nest-asyncio
    sqlalchemy
    transformers
    torch
    nltk
    aiostream
  ];

  meta = with lib; {
    description = "LlamaIndex (formerly GPT Index) is a data framework for your LLM applications ";
    homepage = "https://github.com/run-llama/llama_index";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

}

