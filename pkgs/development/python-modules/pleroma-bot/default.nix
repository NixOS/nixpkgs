{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests-mock
, oauthlib
, requests_oauthlib
, requests
, pyaml
}:

buildPythonPackage rec {
  pname = "pleroma-bot";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "robertoszek";
    repo = "pleroma-bot";
    rev = version;
    sha256 = "1q0xhgqq41zbqiawpd4kbdx41zhwxxp5ipn1c2rc8d7pjyb5p75w";
  };

  propagatedBuildInputs = [ pyaml requests requests_oauthlib oauthlib ];
  checkInputs = [ pytestCheckHook requests-mock ];

  pythonImportsCheck = [ "pleroma_bot" ];

  meta = with lib; {
    homepage = "https://robertoszek.github.io/pleroma-bot/";
    description = "Bot for mirroring one or multiple Twitter accounts in Pleroma/Mastodon";
    license = licenses.mit;
    maintainers = with maintainers; [ robertoszek ];
  };
}
