{
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  inline-snapshot,
  lib,
  pytest,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "http-snapshot";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karpetrosyan";
    repo = "http-snapshot";
    tag = finalAttrs.version;
    hash = "sha256-4roxtwzB3HXwvlBqjdHEit4flXlogVwzlYNgQE8vFwE=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    pytest
  ];

  dependencies = [
    inline-snapshot
  ];

  optional-dependencies = {
    httpx = [ httpx ];
    requests = [ requests ];
  };

  pythonImportsCheck = [ "http_snapshot" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [
    "--inline-snapshot=disable"
  ];

  meta = {
    changelog = "https://github.com/karpetrosyan/http-snapshot/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Pytest plugin that snapshots requests made with popular Python HTTP clients";
    homepage = "https://github.com/karpetrosyan/http-snapshot";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
