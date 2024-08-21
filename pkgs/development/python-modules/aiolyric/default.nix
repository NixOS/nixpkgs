{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  incremental,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiolyric";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "aiolyric";
    rev = "refs/tags/${version}";
    hash = "sha256-pN/F4Rdov06sm1yfJQEzmWyujWVeVU+bNGGkgnN4jYw=";
  };

  postPatch = ''
    substituteInPlace requirements_setup.txt \
      --replace-fail "==" ">="
  '';

  build-system = [
    incremental
    setuptools
  ];

  dependencies = [
    aiohttp
    incremental
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiolyric" ];

  meta = with lib; {
    description = "Python module for the Honeywell Lyric Platform";
    homepage = "https://github.com/timmo001/aiolyric";
    changelog = "https://github.com/timmo001/aiolyric/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
