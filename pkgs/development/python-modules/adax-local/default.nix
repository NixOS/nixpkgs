{
  lib,
  aiohttp,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  async-timeout,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "adax-local";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyAdaxLocal";
    tag = version;
    hash = "sha256-HdhatjlN4oUzBV1cf/PfgOJbEks4KBdw4vH8Y/z6efQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    bleak
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "adax_local" ];

  meta = with lib; {
    description = "Module for local access to Adax";
    homepage = "https://github.com/Danielhiversen/pyAdaxLocal";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
