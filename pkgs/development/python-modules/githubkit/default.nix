{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  hishel,
  httpx,
  poetry-core,
  pydantic,
  pyjwt,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "githubkit";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yanyongyu";
    repo = "githubkit";
    tag = "v${version}";
    hash = "sha256-ewPCALnkGDhzxn3P9GO5QUaFZDhqsbQNeCmyTCXd7kE=";
  };

  pythonRelaxDeps = [ "hishel" ];

  build-system = [ poetry-core ];

  dependencies = [
    hishel
    httpx
    pydantic
    typing-extensions
  ];

  optional-dependencies = {
    all = [
      anyio
      pyjwt
    ];
    jwt = [ pyjwt ];
    auth-app = [ pyjwt ];
    auth-oauth-device = [ anyio ];
    auth = [
      anyio
      pyjwt
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "githubkit" ];

  disabledTests = [
    # Tests require network access
    "test_graphql"
    "test_async_graphql"
    "test_call"
    "test_async_call"
    "test_versioned_call"
    "test_versioned_async_call"
  ];

  meta = {
    description = "GitHub SDK for Python";
    homepage = "https://github.com/yanyongyu/githubkit";
    changelog = "https://github.com/yanyongyu/githubkit/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
