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
  version = "1.3.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qg2wm6ddsfai788chylr5ynrvakwg91q3dszz7dxzbkfdcxixj3";
  };

  patches = [
    (fetchpatch {
      name = "remove-entry_point.patch";
      url = "https://github.com/bdraco/aiodiscover/commit/4c497fb7d4c8685a78209c710e92e0bd17f46bb2.patch";
      sha256 = "0py9alhg6qdncbn6a04mrnjhs4j19kg759dv69knpqzryikcfa63";
    })
  ];

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
