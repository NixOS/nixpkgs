{
  lib,
  aiodns,
  buildPythonPackage,
  cached-ipaddress,
  fetchFromGitHub,
  ifaddr,
  netifaces,
  poetry-core,
  pyroute2,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodiscover";
    tag = "v${version}";
    hash = "sha256-q0HXANSfoDPlGdokfiQcsMHkt9ZmD604JRL/SDQx2hw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiodns
    cached-ipaddress
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

  meta = {
    description = "Python module to discover hosts via ARP and PTR lookup";
    homepage = "https://github.com/bdraco/aiodiscover";
    changelog = "https://github.com/bdraco/aiodiscover/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
