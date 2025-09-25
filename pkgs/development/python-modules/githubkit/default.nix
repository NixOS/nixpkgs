{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  hishel,
  httpx,
  pydantic,
  pyjwt,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "githubkit";
  version = "0.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yanyongyu";
    repo = "githubkit";
    tag = "v${version}";
    hash = "sha256-4THc5BNQGSrpf3Y3OoFisywEdKp8ZgNjle4yvVLUy1A=";
  };

  pythonRelaxDeps = [ "hishel" ];

  build-system = [ uv-build ];

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
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

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
    changelog = "https://github.com/yanyongyu/githubkit/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
