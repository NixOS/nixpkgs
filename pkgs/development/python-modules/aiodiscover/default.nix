{ lib
, async-dns
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, ifaddr
, pyroute2
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiodiscover";
  version = "1.3.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    sha256 = "186agrjx818vn00d3pqlka5ir48rgpbfyn1cifkn9ylsxg9cz3ph";
  };

  propagatedBuildInputs = [
    async-dns
    pyroute2
    ifaddr
  ];

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner>=5.2",' ""
  '';

  # Tests require access to /etc/resolv.conf
  # pythonImportsCheck doesn't work as async-dns wants to create its CONFIG_DIR
  doCheck = false;

  meta = with lib; {
    description = "Python module to discover hosts via ARP and PTR lookup";
    homepage = "https://github.com/bdraco/aiodiscover";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
