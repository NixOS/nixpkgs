{
  lib,
  aiodns,
  async-timeout,
  buildPythonPackage,
  cached-ipaddress,
  fetchFromGitHub,
  ifaddr,
  netifaces,
  poetry-core,
  pyroute2,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiodiscover";
    rev = "refs/tags/v${version}";
    hash = "sha256-A12YeNIm9Pv4zpzaejTk8VvLzKLHxZV2EzVpchLX1k8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "-v -Wdefault --cov=aiodiscover --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    async-timeout
    aiodns
    cached-ipaddress
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

  pythonImportsCheck = [ "aiodiscover" ];

  meta = with lib; {
    description = "Python module to discover hosts via ARP and PTR lookup";
    homepage = "https://github.com/bdraco/aiodiscover";
    changelog = "https://github.com/bdraco/aiodiscover/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
