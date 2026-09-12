{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  httpx,
  lib,
  platformdirs,
}:

buildPythonPackage (finalAttrs: {
  pname = "oauth-cli-kit";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pinhua33";
    repo = "oauth-cli-kit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q/42oWwhc/GX2VRVGV+8dLQ6LgjBIKmh45ZHiW0KL5A=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    httpx
    platformdirs
  ];

  pythonImportsCheck = [ "oauth_cli_kit" ];

  meta = {
    description = "Reusable OAuth 2.0 + PKCE helpers for CLI applications";
    homepage = "https://github.com/pinhua33/oauth-cli-kit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gdifolco ];
  };
})
