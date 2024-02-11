{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
, wheel
, httpx
, pyjwt
, pytest-httpx
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "httpx-auth";
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "httpx_auth";
    rev = "refs/tags/v${version}";
    hash = "sha256-kK31jpS9Ax5kNkvUSbWWIC6CKdZKVJ28kLS0iuntWqg=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pyjwt
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "httpx_auth" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Authentication classes to be used with httpx";
    homepage = "https://github.com/Colin-b/httpx_auth";
    changelog = "https://github.com/Colin-b/httpx_auth/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
