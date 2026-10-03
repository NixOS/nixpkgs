{
  lib,
  fetchFromCodeberg,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tooi";
  version = "0.27.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ihabunek";
    repo = "tooi";
    tag = finalAttrs.version;
    hash = "sha256-FEVLGDkYFOvbhXFMq+a2Qoc5o0AUUojyQEW5J4uNIEk=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    aiodns
    aiohttp
    beautifulsoup4
    certifi
    click
    html2text
    markdown-it-py
    platformdirs
    pydantic
    rich
    textual
    textual-fspicker
    textual-image
    tomlkit
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "tooi" ];

  meta = {
    description = "Text-based user interface for Mastodon, Pleroma and friends";
    mainProgram = "tooi";
    homepage = "https://codeberg.org/ihabunek/tooi";
    changelog = "https://codeberg.org/ihabunek/tooi/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kybe236 ];
  };
})
