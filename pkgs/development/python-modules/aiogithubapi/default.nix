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
}:

buildPythonPackage rec {
  pname = "aiogithubapi";
  version = "24.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "aiogithubapi";
    rev = "refs/tags/${version}";
    hash = "sha256-z7l7Qx9Kg1FZ9nM0V2NzTyi3gbE2hakbc/GZ1CzDmKw=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0"' 'version = "${version}"'
  '';

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
    sigstore
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "aiogithubapi" ];

  disabledTests = [
    # sigstore.errors.TUFError: Failed to refresh TUF metadata
    "test_sigstore"
  ];

  meta = with lib; {
    description = "Python client for the GitHub API";
    homepage = "https://github.com/ludeeus/aiogithubapi";
    changelog = "https://github.com/ludeeus/aiogithubapi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
