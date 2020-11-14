{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, click
, gtts-token
, mock
, pytest
, requests
, six
, testfixtures
, twine
, urllib3
}:

buildPythonPackage rec {
  pname = "gtts";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "pndurette";
    repo = "gTTS";
    rev = "v${version}";
    sha256 = "1vcsxzqzl61h50lm934hd7q5nl7l10wwymgq1mcynmqxbm1s4rnl";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    click
    gtts-token
    requests
    six
    urllib3
    twine
  ];

  checkInputs = [ pytest mock testfixtures ];

  # majority of tests just try to call out to Google's Translate API endpoint
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "gtts" ];

  meta = with lib; {
    description = "A Python library and CLI tool to interface with Google Translate text-to-speech API";
    homepage = "https://gtts.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ unode ];
  };
}
