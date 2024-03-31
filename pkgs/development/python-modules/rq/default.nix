{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder

# build-system
, hatchling

# dependencies
, click
, redis

# tests
, psutil
, pytestCheckHook
, redis-server
, sentry-sdk
}:

buildPythonPackage rec {
  pname = "rq";
  version = "1.16.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    rev = "refs/tags/v${version}";
    hash = "sha256-1E7jPTSQCjuKZVFL4uZqL1WZHnxWSLTNcnpyvfHz7oY=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    click
    redis
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    sentry-sdk
  ];

  preCheck = lib.optionalString stdenv.isLinux ''
    PATH=$out/bin:$PATH
    ${redis-server}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = lib.optionalString stdenv.isLinux ''
    kill $REDIS_PID
  '';

  pythonImportsCheck = [
    "rq"
  ];

  meta = with lib; {
    description = "Library for creating background jobs and processing them";
    homepage = "https://github.com/nvie/rq/";
    changelog = "https://github.com/rq/rq/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mrmebelman ];
  };
}

