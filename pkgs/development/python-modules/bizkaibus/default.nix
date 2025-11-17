{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bizkaibus";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "UgaitzEtxebarria";
    repo = "BizkaibusRTPI";
    rev = version;
    hash = "sha256-TM02pSSOELRGSwsKc5C+34W94K6mnS0C69aijsPqSWs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "bizkaibus" ];

  meta = with lib; {
    description = "Python module to get information about Bizkaibus buses";
    homepage = "https://github.com/UgaitzEtxebarria/BizkaibusRTPI";
    changelog = "https://github.com/UgaitzEtxebarria/BizkaibusRTPI/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
