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
  version = "2.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pndurette";
    repo = "gTTS";
    tag = "v${version}";
    hash = "sha256-ryTR7cESDO9pH5r2FBz+6JuNMEQr39hil/FSklgaIGg=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "click"
  ];
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

  meta = {
    description = "Python library and CLI tool to interface with Google Translate text-to-speech API";
    mainProgram = "gtts-cli";
    homepage = "https://gtts.readthedocs.io";
    changelog = "https://gtts.readthedocs.io/en/latest/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ unode ];
  };
}
