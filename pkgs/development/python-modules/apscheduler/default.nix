{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gevent,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-tornado,
  pytestCheckHook,
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
  version = "3.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "apscheduler";
    tag = version;
    hash = "sha256-tFEm9yXf8CqcipSYtM7JM6WQ5Qm0YtgWhZvZOBAzy+w=";
  };

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
    pytestCheckHook
    pytz
    tornado
    twisted
  ];

  disabledTests =
    [
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

  meta = with lib; {
    description = "Library that lets you schedule your Python code to be executed";
    homepage = "https://github.com/agronholm/apscheduler";
    license = licenses.mit;
    maintainers = [ ];
  };
}
