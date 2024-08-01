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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pleroma-bot";
  version = "0.8.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "robertoszek";
    repo = pname;
    rev = version;
    hash = "sha256-vJxblpf3NMSyYMHeWG7vHP5AeluTtMtVxOsHgvGDHeA=";
  };

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Bot for mirroring one or multiple Twitter accounts in Pleroma/Mastodon";
    mainProgram = "pleroma-bot";
    homepage = "https://robertoszek.github.io/pleroma-bot/";
    license = licenses.mit;
    maintainers = with maintainers; [ robertoszek ];
  };
}
