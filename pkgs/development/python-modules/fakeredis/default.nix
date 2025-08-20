{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  jsonpath-ng,
  lupa,
  poetry-core,
  pyprobables,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  redis,
  redis-server,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "2.26.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    tag = "v${version}";
    hash = "sha256-jD0e04ltH1MjExfrPsR6LUn4X0/qoJZWzX9i2A58HHI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    redis
    sortedcontainers
  ];

  optional-dependencies = {
    lua = [ lupa ];
    json = [ jsonpath-ng ];
    bf = [ pyprobables ];
    cf = [ pyprobables ];
    probabilistic = [ pyprobables ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fakeredis" ];

  pytestFlagsArray = [ "-m 'not slow'" ];

  preCheck = ''
    ${lib.getExe' redis-server "redis-server"} --port 6390 &
    REDIS_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/dsoftwareinc/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
