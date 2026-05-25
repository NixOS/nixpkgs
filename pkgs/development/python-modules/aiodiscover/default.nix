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

buildPythonPackage (finalAttrs: {
  pname = "aiodiscover";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodiscover";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O5aQ2yCcy6ZtDviH8Jie3BrgS4kPhSDHBVhbXco5oqM=";
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
    changelog = "https://github.com/bdraco/aiodiscover/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
