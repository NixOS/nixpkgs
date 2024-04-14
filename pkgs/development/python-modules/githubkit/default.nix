{ lib
, anyio
, buildPythonPackage
, fetchFromGitHub
, hishel
, httpx
, poetry-core
, pydantic
, pyjwt
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "githubkit";
  version = "0.11.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "yanyongyu";
    repo = "githubkit";
    rev = "refs/tags/v${version}";
    hash = "sha256-GRuEzRqDfhLCanuQnCkMXmDnfNkLFb35Gixl9pWmA8w=";
  };

  pythonRelaxDeps = [
    "hishel"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=githubkit --cov-append --cov-report=term-missing" ""
  '';

  build-system = [
    poetry-core
    pythonRelaxDepsHook
  ];

  dependencies = [
    hishel
    httpx
    pydantic
    typing-extensions
  ];

  passthru.optional-dependencies = {
    all = [
      anyio
      pyjwt
    ];
    jwt = [
      pyjwt
    ];
    auth-app = [
      pyjwt
    ];
    auth-oauth-device = [
      anyio
    ];
    auth = [
      anyio
      pyjwt
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "githubkit"
  ];

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
