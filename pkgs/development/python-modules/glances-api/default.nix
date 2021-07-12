{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "glances-api";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-glances-api";
    rev = version;
    sha256 = "sha256-mbkZZg2fmus4kOXFxHE/UV/nxemFAsoEZu8IUa7SPsg=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "glances_api" ];

  meta = with lib; {
    description = "Python API for interacting with Glances";
    homepage = "https://github.com/home-assistant-ecosystem/python-glances-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
