{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "0.13.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yanyongyu";
    repo = "githubkit";
    tag = "v${version}";
    hash = "sha256-67Y0r4Po3z4YmnbWC0HBLmsKD68HMIGvHKo5SLe+KRc=";
  };

  patches = [
    (fetchpatch2 {
      name = "uv-build.patch";
      url = "https://github.com/yanyongyu/githubkit/commit/2817664d904541242d4cedf7aae85cd4c4b606e2.patch?full_index=1";
      hash = "sha256-mmtjlebHZpHX457frSOe88tsUo7iNdSIUynGZjcjuw4=";
    })
  ];

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
  ++ lib.concatAttrValues optional-dependencies;

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
