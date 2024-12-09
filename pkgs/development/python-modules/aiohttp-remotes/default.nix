{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytest-aiohttp,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aiohttp-remotes";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp-remotes";
    rev = "refs/tags/v${version}";
    hash = "sha256-/bcYrpZfO/sXc0Tcpr67GBqCu4ZSAVmUj9kzupIHHnM=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    aiohttp
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_remotes" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Set of useful tools for aiohttp.web server";
    homepage = "https://github.com/wikibusiness/aiohttp-remotes";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss ];
  };
}
