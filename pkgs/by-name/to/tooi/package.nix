{
  lib,
  fetchFromCodeberg,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tooi";
  version = "0.24.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ihabunek";
    repo = "tooi";
    tag = finalAttrs.version;
    hash = "sha256-+xNbOipfUVu4bqyCU+ECOBGZS5hsqQ/HmpNRZAjlJZg=";
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
  ];

  meta = {
    description = "A text-based user interface for Mastodon, Pleroma and friends";
    mainProgram = "tooi";
    homepage = "https://codeberg.org/ihabunek/tooi";
    changelog = "https://codeberg.org/ihabunek/tooi/src/tag/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kybe236
    ];
  };
})
