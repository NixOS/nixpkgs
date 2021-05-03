{ lib
, async-dns
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, pyroute2
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "1.3.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TmWl5d5HwyqWPUjwtEvc5FzVfxV/K1pekljcMkGN0Ag=";
  };

  propagatedBuildInputs = [
    async-dns
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

  preBuild = ''
    export HOME=$TMPDIR
  '';

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
