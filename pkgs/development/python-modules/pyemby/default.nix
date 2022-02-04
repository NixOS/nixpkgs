{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyemby";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = pname;
    rev = version;
    sha256 = "sha256-EpmXdyKtfb/M8rTv6YrfNCpDmKei2AD5DBcdVvqCVWw=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyemby" ];

  meta = with lib; {
    description = "Python library to interface with the Emby API";
    homepage = "https://github.com/mezz64/pyemby";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
