{
  lib,
  buildPythonPackage,
  debugpy,
  docker,
  fetchFromGitHub,
  kombu,
  poetry-core,
  psutil,
  pytest-docker-tools,
  pytest,
  tenacity,

  # optional dependencies
  redis,
  python-memcached,
  boto3,
  botocore,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pytest-celery";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "pytest-celery";
    tag = "v${version}";
    hash = "sha256-E8GO/00IC9kUvQLZmTFaK4FFQ7d+/tw/kVTQbAqRRRM=";
  };

  postPatch = ''
    # Avoid infinite recursion with celery
    substituteInPlace pyproject.toml \
      --replace 'celery = { version = "*" }' ""
  '';

  pythonRelaxDeps = [
    "debugpy"
  ];

  pythonRemoveDeps = [
    "celery" # cyclic dependency
    "setuptools" # https://github.com/celery/pytest-celery/pull/464
  ];

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  dependencies = [
    debugpy
    docker
    kombu
    psutil
    pytest-docker-tools
    tenacity
  ];

  optional-dependencies = {
    all = [
      redis
      python-memcached
      boto3
      botocore
      urllib3
    ];
    redis = [ redis ];
    memcached = [ python-memcached ];
    sqs = [
      boto3
      botocore
      urllib3
    ];
  };

  # Infinite recursion with celery
  doCheck = false;

  meta = {
    description = "Pytest plugin to enable celery.contrib.pytest";
    homepage = "https://github.com/celery/pytest-celery";
    changelog = "https://github.com/celery/pytest-celery/blob/${src.tag}/Changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
