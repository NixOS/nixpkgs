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
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "pndurette";
    repo = "gTTS";
    rev = "v${version}";
    sha256 = "1a984691kfin1n896p5l7y8ggjzx19ynih2cw040smfms0azhp4w";
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
