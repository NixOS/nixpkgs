{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  poetry-core,
  cryptography,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-http-message-signatures";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "dev.funkwhale.audio";
    owner = "funkwhale";
    repo = "requests-http-message-signatures";
    tag = version;
    hash = "sha256-1GObY+bF5wwgjDORUlO61bmIadK+EpZtyYGMgS9Bqzg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cryptography
    requests
  ];

  # Tests require network access.
  doCheck = false;

  pythonImportsCheck = [ "requests_http_message_signatures" ];

  meta = {
    description = "Request authentication plugin implementing IETF HTTP Message Signatures";
    homepage = "https://dev.funkwhale.audio/funkwhale/requests-http-message-signatures";
    changelog = "https://dev.funkwhale.audio/funkwhale/requests-http-message-signatures/-/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    teams = [ lib.teams.ngi ];
  };
}
