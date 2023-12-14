{ lib, stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, setuptools
, poetry-core, pydantic, dataclasses-json, httpx, tiktoken
, openai, deprecated, tenacity, numpy, beautifulsoup4, pandas, fsspec
, nest-asyncio, sqlalchemy }:

buildPythonPackage rec {
  pname = "llama-index";
  version = "0.9.13";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "llama_index";
    rev = "v${version}";
    hash = "sha256-sXG9yhls3zPHGYCSCJMDp4T02O4kCDp7pr40aWEplt8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "bs4" "beautifulsoup4"
  '';

  nativeBuildInputs = [ setuptools poetry-core ];

  propagatedBuildInputs = [
    pydantic
    dataclasses-json
    httpx
    tiktoken
    openai
    deprecated
    tenacity
    numpy
    beautifulsoup4
    pandas
    fsspec
    nest-asyncio
    sqlalchemy
  ];

  # skip checks as llama_index requires network connection on initial import

  meta = with lib; {
    changelog =
      "https://github.com/run-llama/llama_index/releases/tag/${version}";
    description =
      "LlamaIndex (formerly GPT Index) is a data framework for your LLM applications";
    homepage = "https://github.com/run-llama/llama_index";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
