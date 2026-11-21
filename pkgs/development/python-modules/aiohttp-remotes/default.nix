{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytest-aiohttp,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiohttp-remotes";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp-remotes";
    tag = "v${version}";
    hash = "sha256-eFDUc18zGGLkc5Ip87r+UAX6+yzbFGhHo9g8m20hFk0=";
  };

  # flit-core 4 is not packaged yet, 3.x builds this package fine
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"flit_core >=4.1.0,<5"' '"flit_core"'
  '';

  build-system = [
    flit-core
  ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_remotes" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Set of useful tools for aiohttp.web server";
    homepage = "https://github.com/wikibusiness/aiohttp-remotes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss ];
  };
}
