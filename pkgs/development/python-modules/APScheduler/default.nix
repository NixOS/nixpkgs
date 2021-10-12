{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
, pytest-asyncio
, pytest-tornado
, sqlalchemy
, tornado
, twisted
, mock
, gevent
, six
, pytz
, tzlocal
, funcsigs
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "APScheduler";
  version = "3.8.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "793b2d37c52ece53e34626619e6142e99b20b59a12155f39e1e6932e324f079d";
  };

  buildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytest-asyncio
    pytest-tornado
    pytestCheckHook
    sqlalchemy
    tornado
    twisted
    mock
    gevent
  ];

  propagatedBuildInputs = [
    six
    pytz
    tzlocal
    funcsigs
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov --tb=short" ""
  '';

  disabledTests = [
    "test_broken_pool"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_submit_job"
    "test_max_instances"
  ];

  pythonImportsCheck = [ "apscheduler" ];

  meta = with lib; {
    description = "A Python library that lets you schedule your Python code to be executed";
    homepage = "https://github.com/agronholm/apscheduler";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
