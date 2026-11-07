{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tiddl";
  version = "3.4.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oskvr37";
    repo = "tiddl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wwcdGGIyBhybToHPw+6G+sMZwtJiTOHpYQpqt2MrKtE=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiofiles
    aiohttp
    m3u8
    mutagen
    pydantic
    requests
    requests-cache
    typer
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    python3Packages.pytestCheckHook
    python3Packages.pytest-mock
  ];

  meta = {
    changelog = "https://github.com/oskvr37/tiddl/releases/tag/v${finalAttrs.version}";
    description = "CLI app Tidal downloader that supports master quality";
    homepage = "https://github.com/oskvr37/tiddl";
    license = lib.licensesSpdx."Apache-2.0";
    mainProgram = "tiddl";
    maintainers = [ lib.maintainers.quantenzitrone ];
  };
})
