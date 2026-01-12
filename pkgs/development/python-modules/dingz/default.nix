{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  click,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "dingz";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-dingz";
    rev = version;
    hash = "sha256-bCytQwLWw8D1UkKb/3LQ301eDCkVR4alD6NHjTs6I+4=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    click
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "dingz" ];

  meta = {
    description = "Python API for interacting with Dingz devices";
    mainProgram = "dingz";
    homepage = "https://github.com/home-assistant-ecosystem/python-dingz";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
