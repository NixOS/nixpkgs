{
  lib,
  aiohttp,
  aresponses,
  async-timeout,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  sigstore,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "aiogithubapi";
  version = "25.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "aiogithubapi";
    tag = version;
    hash = "sha256-zl9QpFpkvSTs0BUDMBmwTeLY1YvNRSqbkIZ5LDUP3zw=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0"' 'version = "${version}"'
  '';

  pythonRelaxDeps = [ "async-timeout" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
    backoff
  ];

  # Optional dependencies for deprecated-verify are not added
  # Only sigstore < 2 is supported

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  preCheck = ''
    # Need sigstore is an optional dependencies and need <2
    rm -rf tests/test_helper.py
  '';

  pythonImportsCheck = [ "aiogithubapi" ];

  meta = {
    description = "Python client for the GitHub API";
    homepage = "https://github.com/ludeeus/aiogithubapi";
    changelog = "https://github.com/ludeeus/aiogithubapi/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
