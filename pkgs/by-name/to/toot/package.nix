{
  lib,
  fetchFromGitHub,
  python3Packages,
  nixosTests,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "toot";
  version = "0.51.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "toot";
    tag = finalAttrs.version;
    hash = "sha256-PZMh11MeJaKipt3E1reZQdL8+qz7gY/8bKleRPjshzI=";
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
    changelog = "https://github.com/ihabunek/toot/blob/refs/tags/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      aleksana
    ];
  };
})
