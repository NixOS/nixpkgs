{ lib
, buildPythonPackage
, dnspython
, fetchFromGitHub
, ifaddr
, pyroute2
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "1.4.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xiIN/YLIOdPuqenyxybu0iUpYEy3MyBssXswza5InU0=";
  };

  propagatedBuildInputs = [
    dnspython
    pyroute2
    ifaddr
  ];

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner>=5.2",' ""
  '';

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require access to /etc/resolv.conf
    "test_async_discover_hosts"
  ];

  pythonImportsCheck = ["aiodiscover"];

  meta = with lib; {
    description = "Python module to discover hosts via ARP and PTR lookup";
    homepage = "https://github.com/bdraco/aiodiscover";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
