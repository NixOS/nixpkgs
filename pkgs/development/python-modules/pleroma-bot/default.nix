{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests-mock,
  oauthlib,
  requests-oauthlib,
  requests,
  pyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pleroma-bot";
  version = "0.8.6";
  pyproject = true;
  build-system = [ setuptools ];
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "robertoszek";
    repo = "pleroma-bot";
    tag = finalAttrs.version;
    hash = "sha256-vJxblpf3NMSyYMHeWG7vHP5AeluTtMtVxOsHgvGDHeA=";
  };

  dependencies = [
    pyaml
    requests
    requests-oauthlib
    oauthlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "pleroma_bot" ];

  meta = {
    description = "Bot for mirroring one or multiple Twitter accounts in Pleroma/Mastodon";
    mainProgram = "pleroma-bot";
    homepage = "https://robertoszek.github.io/pleroma-bot/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ robertoszek ];
  };
})
