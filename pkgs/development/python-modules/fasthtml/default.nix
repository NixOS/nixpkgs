{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,

  fastcore,
  python-dateutil,
  starlette,
  oauthlib,
  itsdangerous,
  uvicorn,
  httpx,
  fastlite,
  python-multipart,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "fasthtml";
  version = "0.12.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fasthtml";
    rev = version;
    hash = "sha256-atumS2tbOEzSiqizVlU1AvBXHMuTIJhNeQTMVfz1fkY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fastcore
    python-dateutil
    starlette
    oauthlib
    itsdangerous
    uvicorn
    httpx
    fastlite
    python-multipart
    beautifulsoup4
  ];

  pythonImportsCheck = [
    "fasthtml"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The fastest way to create an HTML app";
    homepage = "https://github.com/AnswerDotAI/fasthtml";
    changelog = "https://github.com/AnswerDotAI/fasthtml/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ x123 ];
  };
}
