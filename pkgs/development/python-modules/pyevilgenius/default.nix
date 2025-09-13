{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  async-timeout,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyevilgenius";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pyevilgenius";
    rev = version;
    hash = "sha256-wjC32oq/lW3Z4XB+4SILRKIOuCgBKk1gruOo4uc/4/o=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "pyevilgenius" ];

  meta = with lib; {
    description = "Python SDK to interact with Evil Genius Labs devices";
    homepage = "https://github.com/home-assistant-libs/pyevilgenius";
    changelog = "https://github.com/home-assistant-libs/pyevilgenius/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
