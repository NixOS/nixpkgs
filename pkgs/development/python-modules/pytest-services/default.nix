{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  memcached,
  psutil,
  pylibmc,
  pytest,
  pytestCheckHook,
  requests,
  setuptools-scm,
  toml,
  xvfb,
  zc-lockfile,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-services";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-services";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6FyyotxVkGijtxt9//6iivWfdcU0xOMmbuyTlbgflgo=";
  };

  build-system = [
    setuptools-scm
    toml
  ];

  buildInputs = [ pytest ];

  dependencies = [
    requests
    psutil
    zc-lockfile
  ];

  optional-dependencies = {
    memcached = [ pylibmc ];
  };

  nativeCheckInputs = [
    memcached
    pytestCheckHook
    xvfb
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "pytest_services" ];

  disabledTests = [
    # Tests require binaries and additional parts
    "test_mysql"
  ];

  # Tests use sockets
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Services plugin for pytest testing framework";
    homepage = "https://github.com/pytest-dev/pytest-services";
    changelog = "https://github.com/pytest-dev/pytest-services/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
