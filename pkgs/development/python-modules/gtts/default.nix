{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  beautifulsoup4,
  click,
  gtts-token,
  mock,
  pytest,
  requests,
  six,
  testfixtures,
  twine,
  urllib3,
}:

buildPythonPackage rec {
  pname = "gtts";
  version = "2.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pndurette";
    repo = "gTTS";
    rev = "refs/tags/v${version}";
    hash = "sha256-CCxD73fpHGsO4zSifWLQtgDkbPvPEnA2357umhOCNoI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    click
    gtts-token
    requests
    six
    urllib3
    twine
  ];

  nativeCheckInputs = [
    pytest
    mock
    testfixtures
  ];

  # majority of tests just try to call out to Google's Translate API endpoint
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "gtts" ];

  meta = with lib; {
    description = "A Python library and CLI tool to interface with Google Translate text-to-speech API";
    mainProgram = "gtts-cli";
    homepage = "https://gtts.readthedocs.io";
    changelog = "https://gtts.readthedocs.io/en/latest/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ unode ];
  };
}
