{
  lib,
  aiodns,
  buildPythonPackage,
  cached-ipaddress,
  fetchFromGitHub,
  ifaddr,
  libredirect,
  netifaces,
  poetry-core,
  pyroute2,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiodiscover";
  version = "3.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodiscover";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yrXy665O9VZ3aWn23QQCJm5USBV0P5aTSsQU5QGIcP8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiodns
    cached-ipaddress
    ifaddr
    netifaces
    pyroute2
  ];

  pythonRelaxDeps = [ "aiodns" ];

  nativeCheckInputs = [
    libredirect.hook
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  preCheck = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/resolv.conf=$(realpath resolv.conf)
  '';

  pythonImportsCheck = [ "aiodiscover" ];

  meta = {
    description = "Python module to discover hosts via ARP and PTR lookup";
    homepage = "https://github.com/bdraco/aiodiscover";
    changelog = "https://github.com/bdraco/aiodiscover/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
