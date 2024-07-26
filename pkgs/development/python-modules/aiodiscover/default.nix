{ lib
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
  version = "1.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodiscover";
    rev = "refs/tags/v${version}";
    hash = "sha256-M3tus0r58YVJyi/S7UWq+OvaKke3hqkHGuYkUxEpVxg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-timeout
    cached-ipaddress
    dnspython
    netifaces
    pyroute2
    ifaddr
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
