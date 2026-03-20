{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build system
  setuptools,
  setuptools-scm,
  # runtime
  httpx,
  pydantic,
  requests,
  tenacity,
  types-requests,
}:

buildPythonPackage rec {
  pname = "retryhttp";
  version = "1.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "austind";
    repo = "retryhttp";
    tag = "release/v${version}";
    hash = "sha256-Jz073CTeIfPjcOQUGdb6/Q5OfEXZW5hTiEPKrfAK0Gg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    httpx
    pydantic
    requests
    tenacity
    types-requests
  ];

  pythonImportsCheck = [ "retryhttp" ];

  meta = {
    description = "Retry potentially transient HTTP errors in Python";
    homepage = "https://github.com/austind/retryhttp";
    changelog = "https://github.com/austind/retryhttp/releases/tag/release%2Fv${version}";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
}
