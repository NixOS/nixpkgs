{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pycfdns";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-bLzDakxKq8fcjEKSxc6D5VN9gfAu1M3/zaAU2UYnwSs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version="0",' 'version="${version}",'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pycfdns"
  ];

  meta = with lib; {
    description = "Python module for updating Cloudflare DNS A records";
    homepage = "https://github.com/ludeeus/pycfdns";
    changelog = "https://github.com/ludeeus/pycfdns/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
