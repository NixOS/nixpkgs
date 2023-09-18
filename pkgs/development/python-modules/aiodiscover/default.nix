{ lib
, async-timeout
, buildPythonPackage
, dnspython
, fetchFromGitHub
, ifaddr
, netifaces
, pyroute2
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rFypv0gCj+Jskk+dlRNJ2ufj2sDud7AuJzj3cl4bB4Y=";
  };

  propagatedBuildInputs = [
    async-timeout
    dnspython
    netifaces
    pyroute2
    ifaddr
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner>=5.2",' ""
  '';

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
