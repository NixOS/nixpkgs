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
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    rev = version;
    sha256 = "0qbsk5iv3vrpwz7kfmjdbc66rfkg788p6wwxbf6jzfarfhcgrh3k";
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

  disabledTests = [
    # RuntimeError: coroutine 'test_remigrate_forcibly_downgraded_v4' was never awaited
    #"test_remigrate_forcibly_downgraded_v4"
    # RuntimeError: Event loop is closed
    "test_thread_already_stopped"
  ];

  pythonImportsCheck = [
    "bellows"
  ];

  meta = with lib; {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
  };
}
