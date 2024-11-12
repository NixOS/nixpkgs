{
  lib,
  aiodns,
  async-timeout,
  buildPythonPackage,
  cached-ipaddress,
  dnspython,
  fetchFromGitHub,
  ifaddr,
  netifaces,
  poetry-core,
  pyroute2,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodiscover";
    rev = "refs/tags/v${version}";
    hash = "sha256-A12YeNIm9Pv4zpzaejTk8VvLzKLHxZV2EzVpchLX1k8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
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
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require access to /etc/resolv.conf
    "test_async_discover_hosts"
  ];

  pythonImportsCheck = [ "aiodiscover" ];

  meta = with lib; {
    description = "Python module to discover hosts via ARP and PTR lookup";
    homepage = "https://github.com/bdraco/aiodiscover";
    changelog = "https://github.com/bdraco/aiodiscover/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
