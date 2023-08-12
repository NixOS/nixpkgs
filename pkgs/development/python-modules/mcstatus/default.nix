{ lib
, asyncio-dgram
, buildPythonPackage
, click
, dnspython
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-rerunfailures
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mcstatus";
  version = "11.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "py-mine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+r6WL59T9rNAKl3r4Hef75uJoD7DRYA23uS/OlzRyRk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace " --cov=mcstatus --cov-append --cov-branch --cov-report=term-missing -vvv --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asyncio-dgram
    click
    dnspython
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-rerunfailures
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mcstatus"
  ];

  disabledTests = [
    # DNS features are limited in the sandbox
    "test_query"
    "test_query_retry"
  ];

  meta = with lib; {
    description = "Python library for checking the status of Minecraft servers";
    homepage = "https://github.com/py-mine/mcstatus";
    changelog = "https://github.com/py-mine/mcstatus/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
