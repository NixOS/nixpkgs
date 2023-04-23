{ lib
, asyncio-dgram
, buildPythonPackage
, click
, dnspython
, fetchFromGitHub
, mock
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mcstatus";
  version = "10.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "py-mine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LHcLqP9IGqi0YmjgFoTwojyS+IZmBOBujYWMPuqNc6w=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asyncio-dgram
    click
    dnspython
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace " --cov=mcstatus --cov-append --cov-branch --cov-report=term-missing -vvv --no-cov-on-fail" "" \
      --replace 'asyncio-dgram = "2.1.2"' 'asyncio-dgram = ">=2.1.2"' \
      --replace 'dnspython = "2.2.1"' 'dnspython = ">=2.2.0"'
  '';

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
