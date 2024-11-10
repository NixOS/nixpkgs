{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  pytestCheckHook,
  pytest-asyncio,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiohttp-basicauth";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "aiohttp-basicauth";
    rev = "refs/tags/v${version}";
    hash = "sha256-DjwrMlkVVceA5kDzm0c/on0VMOxyMMA3Hu4Y2Tiu0lI=";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "aiohttp_basicauth" ];

  meta = with lib; {
    description = "HTTP basic authentication middleware for aiohttp 3.0";
    homepage = "https://github.com/romis2012/aiohttp-basicauth";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
