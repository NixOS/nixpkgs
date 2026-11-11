{
  lib,
  aiofiles,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  hatchling,
  httpx,
  httpx2,
  primp,
  pyrate-limiter,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "httpxthrottlecache";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paultiq";
    repo = "httpxthrottlecache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UTio/RU/r8pAhtogIKvOunC554BHmQ6UfhQ0OaELmqM=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    aiofiles
    filelock
    pyrate-limiter
  ];

  optional-dependencies = {
    httpx = [ httpx ];
    httpx2 = [ httpx2 ];
    primp = [ primp ];
  };

  # Provides the optional HTTP client that `pythonImportsCheck` imports. The
  # upstream test suite is not run: it talks to SEC EDGAR and requires
  # EDGAR_IDENTITY to be set.
  nativeCheckInputs = [ httpx ];

  pythonImportsCheck = [ "httpxthrottlecache" ];

  meta = {
    description = "Caching and rate limiting HTTP client for httpx";
    homepage = "https://github.com/paultiq/httpxthrottlecache";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
