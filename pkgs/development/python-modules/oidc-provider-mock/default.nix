{
  buildPythonPackage,
  fetchPypi,
  lib,

  # build-system
  hatchling,
  # dependencies
  authlib,
  flask,
  htpy,
  httpx,
  joserfc,
  pydantic,
  pyyaml,
  typing-extensions,
  uvicorn,
}:
buildPythonPackage (finalAttrs: {
  pname = "oidc-provider-mock";
  version = "0.4.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "oidc_provider_mock";
    inherit (finalAttrs) version;
    hash = "sha256-2ONJxwkVM94f2u61T58ydMrfHj0HBQ5RY8IqvQILjIU=";
  };

  build-system = [ hatchling ];
  dependencies = [
    authlib
    flask
    htpy
    httpx
    joserfc
    pydantic
    pyyaml
    typing-extensions
    uvicorn
  ];

  pythonImportsCheck = [ "oidc_provider_mock" ];

  meta = {
    description = "A mock OpenID Provider server to test and develop OpenID Connect authentication";
    homepage = "https://github.com/geigerzaehler/oidc-provider-mock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stefanboca ];
    mainProgram = "oidc-provider-mock";
  };
})
