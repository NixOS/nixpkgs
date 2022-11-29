{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pycfdns";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-2vjeoI+IqvCIHb51BLkuTISbG0PxFGHlmpSiCaV+E0w=";
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
