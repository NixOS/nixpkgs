{
  lib,
  fetchFromGitHub,
  python3Packages,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "toot";
  version = "0.50.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "toot";
    tag = version;
    hash = "sha256-qcxJeUDRYVFcyrvecG5xGy02O7otj1fg0HgBMuGS1d4=";
  };

  nativeCheckInputs = with python3Packages; [ pytest ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    python-dateutil
    requests
    beautifulsoup4
    wcwidth
    urwid
    tomlkit
    click
    pillow
    term-image
  ];

  checkPhase = ''
    runHook preCheck
    py.test
    runHook postCheck
  '';

  passthru.tests.toot = nixosTests.pleroma;

  meta = {
    description = "Mastodon CLI interface";
    mainProgram = "toot";
    homepage = "https://github.com/ihabunek/toot";
    changelog = "https://github.com/ihabunek/toot/blob/refs/tags/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      aleksana
    ];
  };
}
