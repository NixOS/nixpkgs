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
<<<<<<< HEAD
  version = "3.10.4";
=======
  version = "3.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "APScheduler";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-5t8HGyfZvomOSGvHlAp75QtK8unafAjwdEqW1L1M70o=";
=======
    hash = "sha256-pJ/CMmkhhBbw5BiQ7qenXtayhPEGMNz+hmq2WWIaNpY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = [
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
