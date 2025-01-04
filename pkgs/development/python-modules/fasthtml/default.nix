{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fasthtml";
    rev = "refs/tags/${version}";
    hash = "sha256-+4QqFdn8IRgR2EYEDv7dCHErc3Nu37M4Vdbt2n3yaV4=";
  };

  build-system = [ setuptools ];

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

  pythonRelaxDeps = [ "fastcore" ];

  pythonImportsCheck = [ "fasthtml" ];

  doCheck = false; # no tests

  meta = {
    description = "The fastest way to create an HTML app";
    homepage = "https://fasthl.ml/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
