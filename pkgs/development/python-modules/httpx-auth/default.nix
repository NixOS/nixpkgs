{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pyjwt
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, time-machine
}:

buildPythonPackage rec {
  pname = "httpx-auth";
  version = "0.21.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "httpx_auth";
    rev = "refs/tags/v${version}";
    hash = "sha256-tKEYFoIHxiBG18JWyCHzQEwUvrWk/zuCWqj1uYsmh84=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pyjwt
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    time-machine
  ];

  pythonImportsCheck = [
    "httpx_auth"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Authentication classes to be used with httpx";
    homepage = "https://github.com/Colin-b/httpx_auth";
    changelog = "https://github.com/Colin-b/httpx_auth/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
