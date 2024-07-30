{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiohttp-fast-url-dispatcher";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiohttp-fast-url-dispatcher";
    rev = "refs/tags/v${version}";
    hash = "sha256-DZTW9CazcUY3hyxr0MbVfM/yJzUzwN43c2n07Sloxa8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=aiohttp_fast_url_dispatcher --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_fast_url_dispatcher" ];

  meta = with lib; {
    description = "Faster URL dispatcher for aiohttp";
    homepage = "https://github.com/bdraco/aiohttp-fast-url-dispatcher";
    changelog = "https://github.com/bdraco/aiohttp-fast-url-dispatcher/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
