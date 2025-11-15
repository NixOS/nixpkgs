{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  aiohttp,
  backoff,
  yarl,
  aresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiomodernforms";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wonderslug";
    repo = "aiomodernforms";
    rev = "v${version}";
    hash = "sha256-Vx51WBjjNPIfLlwMnAuwHnGNljhnjKkU0tWB9M9rjsw=";
  };

  patches = [
    # https://github.com/wonderslug/aiomodernforms/pull/274
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/wonderslug/aiomodernforms/commit/61f1330b2fc244565fd97ae392b9778faa1bab09.patch";
      hash = "sha256-7sy5/HgPYgVpULgeEu3tFBa2iXIskAqcarf0RndxTpE=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    backoff
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/wonderslug/aiomodernforms/issues/273
    "test_connection_error"
    "test_empty_response"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aiomodernforms" ];

  meta = with lib; {
    description = "Asynchronous Python client for Modern Forms fans";
    homepage = "https://github.com/wonderslug/aiomodernforms";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
