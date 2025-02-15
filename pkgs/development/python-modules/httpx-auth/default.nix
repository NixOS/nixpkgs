{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pyjwt,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  time-machine,
}:

buildPythonPackage rec {
  pname = "httpx-auth";
  version = "0.23.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "httpx_auth";
    tag = "v${version}";
    hash = "sha256-wrPKUAGBzzuWNtwYtTtqOhb1xqYgc83uxn4rjbfDPmo=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ httpx ];

  nativeCheckInputs = [
    pyjwt
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    time-machine
  ];

  pythonImportsCheck = [ "httpx_auth" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Authentication classes to be used with httpx";
    homepage = "https://github.com/Colin-b/httpx_auth";
    changelog = "https://github.com/Colin-b/httpx_auth/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
