{ lib
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, jsonpath-ng
, lupa
, poetry-core
, pybloom-live
, pyprobables
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, redis
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "2.21.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-2+ZZTWhUb6rj7oWPnDP0PJUHj0CJpOD8iZxmtO4xSbo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    redis
    sortedcontainers
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    lua = [
      lupa
    ];
    json = [
      jsonpath-ng
    ];
    bf = [
      pyprobables
    ];
    cf = [
      pyprobables
    ];
    probabilistic = [
      pyprobables
    ];
  };

  pythonImportsCheck = [
    "fakeredis"
  ];

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/dsoftwareinc/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
