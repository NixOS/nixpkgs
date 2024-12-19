{
  lib,
  buildPythonPackage,
  celery,
  debugpy,
  docker,
  fetchFromGitHub,
  poetry-core,
  psutil,
  pytest-cov-stub,
  pytest-docker-tools,
  pytest,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "pytest-celery";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "celery";
    repo = "pytest-celery";
    rev = "refs/tags/v${version}";
    hash = "sha256-TUtKfGOxvVkiMhsUqyNDK08OTuzzKHrBiPU4JCKsIKM=";
  };

  postPatch = ''
    # Avoid infinite recursion with celery
    substituteInPlace pyproject.toml \
      --replace 'celery = { version = "*" }' ""
  '';

  pythonRelaxDeps = [
    "debugpy"
    "setuptools"
  ];

  build-system = [ poetry-core ];

  buildInput = [ pytest ];

  dependencies = [
    debugpy
    docker
    psutil
    pytest-docker-tools
    setuptools
    tenacity
  ];

  # Infinite recursion with celery
  doCheck = false;

  meta = with lib; {
    description = "Pytest plugin to enable celery.contrib.pytest";
    homepage = "https://github.com/celery/pytest-celery";
    changelog = "https://github.com/celery/pytest-celery/blob/v${version}/Changelog.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
