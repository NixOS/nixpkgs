{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mock,
  nix-update-script,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
  requests-oauthlib,
  responses,
  six,
}:

buildPythonPackage (finalAttrs: {
  version = "0.11.0-unstable-2026-05-15";
  pname = "mwclient";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    rev = "87113730b1f41d8160057621bfd90ad88428f602";
    hash = "sha256-R2erz4oo6111haxlc9zhpgWhihFjMT2Mg/kdWERzcp4=";
  };

  dependencies = [
    requests
    requests-oauthlib
    six
  ];

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "mwclient" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Python client library to the MediaWiki API";
    license = lib.licenses.mit;
    homepage = "https://github.com/mwclient/mwclient";
    maintainers = [ lib.maintainers.klea ];
  };
})
