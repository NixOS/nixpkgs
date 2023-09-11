{ lib
, buildPythonPackage
, click
, click-log
, fetchFromGitHub
, pure-pcapy3
, pyserial-asyncio
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, voluptuous
, zigpy
}:

buildPythonPackage rec {
  pname = "bellows";
  version = "0.36.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    rev = "refs/tags/${version}";
    hash = "sha256-5s2I24gvHRXHm7ZTNZxc6ge9Kbe6UObcY29SvbIUWJg=";
  };

  propagatedBuildInputs = [
    click
    click-log
    pure-pcapy3
    pyserial-asyncio
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [
    "bellows"
  ];

  meta = with lib; {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    changelog = "https://github.com/zigpy/bellows/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
