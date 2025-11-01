{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  setuptools,
  setuptools-scm,
  aioboto3,
  aiohttp,
  anyio,
  beautifulsoup4,
  boto3,
  click,
  debugpy,
  docstring-parser,
  fsspec,
  httpx,
  ijson,
  jsonlines,
  jsonpatch,
  jsonpath-ng,
  jsonref,
  jsonschema,
  mmh3,
  nest-asyncio,
  numpy,
  platformdirs,
  psutil,
  pydantic,
  python-dotenv,
  pyyaml,
  rich,
  s3fs,
  semver,
  shortuuid,
  sniffio,
  tenacity,
  textual,
  typing-extensions,
  universal-pathlib,
  zipp,
}:

buildPythonPackage rec {
  pname = "inspect-ai";
  version = "0.3.140";
  pyproject = true;

  src = fetchPypi {
    pname = "inspect_ai";
    inherit version;
    hash = "sha256-LOyUFLU+0YfTfvBqAUAzc7yLMQu3HBzMNbNqN7MYYjI=";
  };

  build-system = [
    hatchling
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aioboto3
    aiohttp
    anyio
    beautifulsoup4
    boto3
    click
    debugpy
    docstring-parser
    fsspec
    httpx
    ijson
    jsonlines
    jsonpatch
    jsonpath-ng
    jsonref
    jsonschema
    mmh3
    nest-asyncio
    numpy
    platformdirs
    psutil
    pydantic
    python-dotenv
    pyyaml
    rich
    s3fs
    semver
    shortuuid
    sniffio
    tenacity
    textual
    typing-extensions
    universal-pathlib
    zipp
  ];

  doCheck = false;
  pythonImportsCheck = [ "inspect_ai" ];

  meta = {
    description = "Framework for large language model evaluations";
    homepage = "https://github.com/UKGovernmentBEIS/inspect_ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.all;
  };
}
