{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  psutil,
  pylibmc,
  pytest,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
  toml,
  mysqlclient,
  zc-lockfile,
}:

buildPythonPackage rec {
  pname = "pytest-services";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-services";
    rev = "refs/tags/${version}";
    hash = "sha256-E/VcKcAb1ekypm5jP4lsSz1LYJTcTSed6i5OY5ihP30=";
  };

  patches = [
    # Replace distutils.spawn.find_executable with shutil.which, https://github.com/pytest-dev/pytest-services/pull/46
    (fetchpatch {
      name = "replace-distutils.patch";
      url = "https://github.com/pytest-dev/pytest-services/commit/e0e2a85434a2dcbcc0584299c5b2b751efe0b6db.patch";
      hash = "sha256-hvr7EedfjfonHDn6v2slwUBqz1xQoF7Ez/kqAhZRXEc=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
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
    "test_xvfb "
  ];

  meta = with lib; {
    description = "Services plugin for pytest testing framework";
    homepage = "https://github.com/pytest-dev/pytest-services";
    changelog = "https://github.com/pytest-dev/pytest-services/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
