{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gevent,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-tornado,
  pytest8_3CheckHook,
  pythonOlder,
  pytz,
  setuptools,
  setuptools-scm,
  tornado,
  twisted,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "apscheduler";
  version = "3.11.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "apscheduler";
    tag = version;
    hash = "sha256-3KSW1RdiUXlDTr30Wrc8fYb4rRnlOn6lVhBgz3r1D/4=";
  };

  postPatch = ''
    sed -i "/addopts/d" pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    tzlocal
  ];

  nativeCheckInputs = [
    gevent
    pytest-asyncio
    pytest-cov-stub
    pytest-tornado
    pytest8_3CheckHook
    pytz
    tornado
    twisted
  ];

  disabledTests = [
    "test_broken_pool"
    # gevent tests have issue on newer Python releases
    "test_add_live_job"
    "test_add_pending_job"
    "test_shutdown"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_submit_job"
    "test_max_instances"
  ];

  pythonImportsCheck = [ "apscheduler" ];

  meta = {
    changelog = "https://github.com/agronholm/apscheduler/releases/tag/${src.tag}";
    description = "Library that lets you schedule your Python code to be executed";
    homepage = "https://github.com/agronholm/apscheduler";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
