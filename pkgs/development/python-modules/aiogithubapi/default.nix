{
  lib,
  aiohttp,
  aresponses,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  sigstore,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiogithubapi";
  version = "26.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "aiogithubapi";
    tag = finalAttrs.version;
    hash = "sha256-LQFOmg59kusqYtaLQaFePh+4aM25MaXVNkYy3PIeZ5A=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
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
    changelog = "https://github.com/ludeeus/aiogithubapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
