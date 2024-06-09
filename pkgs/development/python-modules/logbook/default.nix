{
  lib,
  brotli,
  buildPythonPackage,
  cython,
  execnet,
  fetchFromGitHub,
  jinja2,
  pytestCheckHook,
  pythonOlder,
  pyzmq,
  redis,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "logbook";
  version = "1.7.0.post0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "getlogbook";
    repo = "logbook";
    rev = "refs/tags/${version}";
    hash = "sha256-bqfFSd7CPYII/3AJCMApqmAYrAWjecOb3JA17FPFMIc=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  passthru.optional-dependencies = {
    execnet = [ execnet ];
    sqlalchemy = [ sqlalchemy ];
    redis = [ redis ];
    zmq = [ pyzmq ];
    compression = [ brotli ];
    jinja = [ jinja2 ];
    all = [
      brotli
      execnet
      jinja2
      pyzmq
      redis
      sqlalchemy
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "logbook" ];

  disabledTests = [
    # Test require Redis instance
    "test_redis_handler"
  ];

  meta = with lib; {
    description = "A logging replacement for Python";
    homepage = "https://logbook.readthedocs.io/";
    changelog = "https://github.com/getlogbook/logbook/blob/${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
