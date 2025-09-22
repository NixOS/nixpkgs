{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  fastapi,
  pyjwt,
  httpx,
  requests,
  pytestCheckHook,
  lib,
}:
buildPythonPackage rec {
  pname = "fastapi-github-oidc";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "fastapi-github-oidc";
    tag = version;
    hash = "sha256-FS50++Hy9h0RFrSnc4PbXFPh/1OO0JOaFdIZwoXa86A=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    fastapi
    pyjwt
    httpx
    requests
  ];

  pythonImportsCheck = [
    "github_oidc.client"
    "github_oidc.server"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_with_auth" # calls github api
  ];

  meta = {
    description = "FastAPI compatible middleware to authenticate Github OIDC Tokens";
    homepage = "https://github.com/atopile/fastapi-github-oidc";
    changelog = "https://github.com/atopile/fastapi-github-oidc/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
