{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  poetry-core,

  eval-type-backport,
  httpx,
  pydantic,
  python-dateutil,
  typing-inspection,

  authlib,
  griffe,
  mcp,

  google-auth,
  requests,

  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "mistralai";
  version = "1.9.3";
  disabled = pythonOlder "3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "client-python";
    rev = "v${version}";
    hash = "sha256-WUmRLaXyfNEVRteZ4Qnbspo331iizOCYZx826qnuscE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    eval-type-backport
    httpx
    pydantic
    python-dateutil
    typing-inspection
  ];

  optional-dependencies = {
    agents = [
      authlib
      griffe
      mcp
    ];
    gcp = [
      google-auth
      requests
    ];
  };

  # pyproject wants generated README-PYPI.md using speakeasy
  # but we can just copy existing README.md
  preBuild = ''
    cp README.md README-PYPI.md
  '';

  pythonImportsCheck = [ "mistralai" ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = {
    description = "Python client library for Mistral AI platform";
    homepage = "https://github.com/mistralai/client-python";
    changelog = "https://github.com/mistralai/client-python/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
