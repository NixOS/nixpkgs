{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  redis,
  redis-server,
  setuptools,
}:

buildPythonPackage rec {
  pname = "logutils";
  version = "0.3.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vAWKJdXCCUYfE04fA8q2N9ZqelzMEuWT21b7snmJmoI=";
  };

  postPatch = ''
    substituteInPlace tests/test_dictconfig.py \
      --replace-fail "assertEquals" "assertEqual"
    substituteInPlace tests/test_redis.py \
      --replace-fail "'redis-server'" "'${redis-server}/bin/redis-server'"
  '';

  build-system = [ setuptools ];

  dependencies = [
    pytestCheckHook
    redis
  ];

  disabledTests = [
    # https://bitbucket.org/vinay.sajip/logutils/issues/4/035-pytest-test-suite-warnings-and-errors
    "test_hashandlers"
  ];

  disabledTestPaths = lib.optionals (stdenv.isDarwin) [
    # Exception: unable to connect to Redis server
    "tests/test_redis.py"
  ];

  pythonImportsCheck = [ "logutils" ];

  meta = with lib; {
    description = "Logging utilities";
    homepage = "https://bitbucket.org/vinay.sajip/logutils/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
