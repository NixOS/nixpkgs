{ lib
, aiodns
, async-timeout
, buildPythonPackage
, cached-ipaddress
, dnspython
, fetchFromGitHub
, ifaddr
, netifaces
, pyroute2
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodiscover";
    rev = "refs/tags/v${version}";
    hash = "sha256-7oeyuwirQ2mm0UQEOwTkAz126UnxkoMjg+DDu5DWY3E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-timeout
    aiodns
    cached-ipaddress
    dnspython
    ifaddr
    netifaces
    pyroute2
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require access to /etc/resolv.conf
    "test_async_discover_hosts"
  ];

  pythonImportsCheck = [
    "aiodiscover"
  ];

  meta = with lib; {
    description = "Python module to discover hosts via ARP and PTR lookup";
    homepage = "https://github.com/bdraco/aiodiscover";
    changelog = "https://github.com/bdraco/aiodiscover/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
