{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  requests,
  pytestCheckHook,
  pytest-cov,
  pytest-responses,
}:

buildPythonPackage (finalAttrs: {
  pname = "menshen-client";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    pname = "menshen_client";
    owner = "suitenumerique";
    repo = "menshen";
    tag = "v${finalAttrs.version}-client";
    hash = "sha256-Y35auBQhGS1+7Y0/IqWoE+OmbUuVffFpSUe9rT1fMCw=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/client";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.17,<0.13" "uv_build"
  '';

  build-system = [ uv-build ];
  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-responses
  ];
  pythonImportsCheck = [ "menshen_client" ];

  meta = {
    description = "An API client for Menshen, the OAuth 2.0 token exchange server";
    homepage = "https://github.com/suitenumerique/meet/";
    license = lib.licenses.mit;
  };
})
