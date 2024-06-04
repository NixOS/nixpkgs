{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  expects,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiosyncthing";
  version = "0.6.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vn8S2/kRW5C2Hbes9oLM4LGm1jWWK0zeLdujR14y6EI=";
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    expects
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=aiosyncthing --cov-report=html" ""
  '';

  pythonImportsCheck = [ "aiosyncthing" ];

  meta = with lib; {
    description = "Python client for the Syncthing REST API";
    homepage = "https://github.com/zhulik/aiosyncthing";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
