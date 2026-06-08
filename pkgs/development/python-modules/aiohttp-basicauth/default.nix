{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "aiohttp-basicauth";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "aiohttp-basicauth";
    tag = "v${version}";
    hash = "sha256-DjwrMlkVVceA5kDzm0c/on0VMOxyMMA3Hu4Y2Tiu0lI=";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "aiohttp_basicauth" ];

  meta = {
    description = "HTTP basic authentication middleware for aiohttp 3.0";
    homepage = "https://github.com/romis2012/aiohttp-basicauth";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
