{ lib
, buildPythonPackage
, fetchPypi
, aiofiles
, beautifulsoup4
, click
, debugpy
, docstring-parser
, fsspec
, httpx
, json-stream
, jsonlines
, nest-asyncio
, numpy
, platformdirs
, psutil
, pydantic
, python-dotenv
, pyyaml
, rich
, s3fs
, semver
, setuptools
, setuptools_scm
, shortuuid
, tenacity
, typing-extensions
}:

buildPythonPackage rec {
  pname = "inspect_ai";
  version = "0.3.17";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lxiUXRyyRq3QtBdMgskCg9Ex3vsNgg7BIH82SRuKrnA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools_scm
  ];

  propagatedBuildInputs = [
    aiofiles
    beautifulsoup4
    click
    debugpy
    docstring-parser
    fsspec
    httpx
    json-stream
    jsonlines
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
    tenacity
    typing-extensions
  ];


  doCheck = false;

  meta = with lib; {
    homepage = "https://inspect.ai-safety-institute.org.uk/";
    changelog = "https://github.com/UKGovernmentBEIS/inspect_ai/blob/main/CHANGELOG.md";
    description = "A framework for large language model evaluations";
    license = licenses.mit;
    maintainers = with maintainers; [ theodoreehrenborg ];
  };
}
