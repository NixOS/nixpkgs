{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  psutil,
  pylibmc,
  pytest,
  pytestCheckHook,
  requests,
  setuptools-scm,
  toml,
  mysqlclient,
  zc-lockfile,
}:

buildPythonPackage rec {
  pname = "pytest-services";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-services";
    tag = "v${version}";
    hash = "sha256-kWgqb7+3/hZKUz7B3PnfxHZq6yU3JUeJ+mruqrMD/NE=";
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

  nativeCheckInputs = [
    mysqlclient
    pylibmc
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_services" ];

  disabledTests = [
    # Tests require binaries and additional parts
    "test_memcached"
    "test_mysql"
    "test_xvfb"
  ];

  # Tests use sockets
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Services plugin for pytest testing framework";
    homepage = "https://github.com/pytest-dev/pytest-services";
    changelog = "https://github.com/pytest-dev/pytest-services/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
