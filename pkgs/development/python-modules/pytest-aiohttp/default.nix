{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, wheel
, aiohttp
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-aiohttp";
  version = "1.0.5";

  format = "pyproject";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "pytest-aiohttp";
    rev = "refs/tags/v${version}";
    hash = "sha256-UACf0frMTOAgSsXQ0oqROHKR1zn4OfLPhd9MwBK002Y=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    aiohttp
    pytest-asyncio
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/aio-libs/pytest-aiohttp/";
    changelog = "https://github.com/aio-libs/pytest-aiohttp/blob/${src.rev}/CHANGES.rst";
    description = "Pytest plugin for aiohttp support";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
