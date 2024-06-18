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
  version = "23.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "aiogithubapi";
    rev = "refs/tags/${version}";
    hash = "sha256-SbpfHKD4QJuCe3QG0GTvsffkuFiGPLEUXOVW9f1gyTI=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace pyproject.toml \
      --replace 'version = "0"' 'version = "${version}"' \
      --replace 'backoff = "^1.10.0"' 'backoff = "*"' \
      --replace 'sigstore = "<2"' 'sigstore = "*"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    backoff
    sigstore
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
