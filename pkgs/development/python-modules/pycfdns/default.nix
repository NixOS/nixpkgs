{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pycfdns";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-bsalfZEkZrBG0/SyEXCWOZyrhOYU/3YJR/78FQTpXYk=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pycfdns"
  ];

  meta = with lib; {
    description = "Python module for updating Cloudflare DNS A records";
    homepage = "https://github.com/ludeeus/pycfdns";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
