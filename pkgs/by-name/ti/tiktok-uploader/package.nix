{
  lib,
  python3,
  fetchFromGitHub,
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "tiktok-uploader";
  version = "59dc978";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wkaisertexas";
    repo = "tiktok-uploader";
    rev = version;
    hash = "sha256-CYefyx6oWmHsXbVjFzulGEGFpFfOJpATjNolN9XryQU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyperclip
    selenium
    webdriver-manager
    toml
    pytz
    hatchling
  ];

  pythonImportsCheck = [
    "tiktok_uploader"
  ];

  meta = {
    description = "Upload TikToks through Python using Selenium";
    homepage = "https://github.com/wkaisertexas/tiktok-uploader";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srghma ];
    mainProgram = "tiktok-uploader";
    platforms = lib.platforms.all;
  };
}
