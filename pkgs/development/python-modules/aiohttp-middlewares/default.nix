{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiohttp-middlewares";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "playpauseandstop";
    repo = "aiohttp-middlewares";
    tag = "v${version}";
    hash = "sha256-jUH1XhkytRwR76wUTsGQGu6m8s+SZ/GO114Lz9atwE8=";
  };

  pythonRelaxDeps = [ "async-timeout" ];

  postPatch = ''
    sed -i "/addopts/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
    yarl
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_middlewares" ];

  meta = with lib; {
    description = "Collection of useful middlewares for aiohttp.web applications";
    homepage = "https://github.com/playpauseandstop/aiohttp-middlewares";
    changelog = "https://github.com/playpauseandstop/aiohttp-middlewares/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
