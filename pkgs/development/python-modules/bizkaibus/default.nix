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
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "UgaitzEtxebarria";
    repo = "BizkaibusRTPI";
    rev = version;
    hash = "sha256-6vQICG63+RJEILElrA1IMOBOJTnHqI9LviqrHBUgj68=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "bizkaibus" ];

  meta = {
    description = "Python module to get information about Bizkaibus buses";
    homepage = "https://github.com/UgaitzEtxebarria/BizkaibusRTPI";
    changelog = "https://github.com/UgaitzEtxebarria/BizkaibusRTPI/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
