{ lib
, fetchFromGitHub
, buildPythonPackage
, async-timeout
, deprecated
, pympler
, wrapt
, pytestCheckHook
, redis
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "coredis";
  version = "4.15.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = pname;
    rev = version;
    hash = "sha256-9nojHufUt53Ovoos4gaR7qh1xN8D1+gJOEyFsOndXJU=";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace "-K" ""
  '';

  propagatedBuildInputs = [
    async-timeout
    deprecated
    pympler
    wrapt
  ];

  pythonImportsCheck = [ "coredis" ];

  nativeCheckInputs = [
    pytestCheckHook
    redis
    pytest-asyncio
  ];

  # all other tests require docker
  pytestFlagsArray = [
    "tests/test_lru_cache.py"
    "tests/test_parsers.py"
    "tests/test_retry.py"
    "tests/test_utils.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/alisaifee/coredis/blob/${src.rev}/HISTORY.rst";
    homepage = "https://github.com/alisaifee/coredis";
    description = "An async redis client with support for redis server, cluster & sentinel";
    license = licenses.mit;
    maintainers = with maintainers; [ netali ];
  };
}
