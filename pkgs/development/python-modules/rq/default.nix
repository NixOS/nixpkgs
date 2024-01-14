{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, click
, redis
, redisServer
, pytestCheckHook
, psutil
, sentry-sdk
}:

buildPythonPackage rec {
  pname = "rq";
  version = "1.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    rev = "refs/tags/v${version}";
    hash = "sha256-cymNXFI+6YEVw2Pc7u6+vroC0428oW7BTLxyBgPqLng=";
  };

  propagatedBuildInputs = [
    click
    redis
  ];

  nativeCheckInputs = [
    pytestCheckHook
    psutil
    sentry-sdk
  ];

  pytestFlagsArray = [
    "tests/test_worker.py"
  ];

  preCheck = ''
    ${redisServer}/bin/redis-server &
    REDIS_PID=$!

    substituteInPlace tests/test_worker.py \
      --replace "'rqworker'" "'$out/bin/rqworker'"
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  pythonImportsCheck = [
    "rq"
  ];

  meta = with lib; {
    description = "Library for creating background jobs and processing them";
    homepage = "https://github.com/rq/rq/";
    changelog = "https://github.com/rq/rq/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mrmebelman ];
  };
}

