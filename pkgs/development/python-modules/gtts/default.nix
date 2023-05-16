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
<<<<<<< HEAD
  version = "2.3.2";
=======
  version = "2.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pndurette";
    repo = "gTTS";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Z5dM/PzIA8qtw0RepTKmHpqBwYMRwNLhWuEC0aBGL3U=";
=======
    hash = "sha256-dbIcx6U5TIy3CteUGrZqcWqOJoZD2HILaJmKDY+j/II=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = [ pytest mock testfixtures ];

  # majority of tests just try to call out to Google's Translate API endpoint
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "gtts" ];

  meta = with lib; {
    description = "A Python library and CLI tool to interface with Google Translate text-to-speech API";
    homepage = "https://gtts.readthedocs.io";
    changelog = "https://gtts.readthedocs.io/en/latest/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ unode ];
  };
}
