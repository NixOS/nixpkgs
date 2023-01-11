{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, gevent
, pytest-asyncio
, pytest-tornado
, pytestCheckHook
, pythonOlder
, pytz
, setuptools
, setuptools-scm
, six
, tornado
, twisted
, tzlocal
}:

buildPythonPackage rec {
  pname = "apscheduler";
  version = "3.9.1.post1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "APScheduler";
    inherit version;
    hash = "sha256-sr6gMJVp2lOnJhv6DOGcZ92/4VG9p3amqQdXn9vT6yo=";
  };

  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pytz
    setuptools
    six
    tzlocal
  ];

  checkInputs = [
    gevent
    pytest-asyncio
    pytest-tornado
    pytestCheckHook
    tornado
    twisted
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov --tb=short" ""
  '';

  disabledTests = [
    "test_broken_pool"
    # gevent tests have issue on newer Python releases
    "test_add_live_job"
    "test_add_pending_job"
    "test_shutdown"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_submit_job"
    "test_max_instances"
  ];

  pythonImportsCheck = [
    "apscheduler"
  ];

  meta = with lib; {
    description = "Library that lets you schedule your Python code to be executed";
    homepage = "https://github.com/agronholm/apscheduler";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
