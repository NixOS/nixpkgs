{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "glances-api";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-glances-api";
    rev = version;
    sha256 = "0rgv77n0lvr7d3vk4qc8svipxafmm6s4lfxrl976hsygrhaqidch";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "glances_api" ];

  meta = with lib; {
    description = "Python Wrapper for interacting with the Volkszahler API";
    homepage = "https://github.com/home-assistant-ecosystem/python-glances-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
