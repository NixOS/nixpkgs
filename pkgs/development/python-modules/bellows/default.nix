{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, click-log
, dataclasses
, pure-pcapy3
, pyserial-asyncio
, voluptuous
, zigpy
, asynctest
, pythonOlder
, pytestCheckHook
, pytest-asyncio
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "bellows";
  version = "0.31.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    rev = "refs/tags/${version}";
    sha256 = "sha256-h0hGTT8ipZZ3l/B6I/O74hFpRzaxj5vUBMbM/xX0dq4=";
  };

  propagatedBuildInputs = [
    click
    click-log
    pure-pcapy3
    pyserial-asyncio
    voluptuous
    zigpy
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ]  ++ lib.optionals (pythonOlder "3.8") [
    asynctest
  ];

  pythonImportsCheck = [
    "bellows"
  ];

  meta = with lib; {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
