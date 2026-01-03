{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,

  anthropic,
  astor,
  fastapi,
  google-generativeai,
  html2image,
  html2text,
  inquirer,
  ipykernel,
  jupyter-client,
  litellm,
  matplotlib,
  platformdirs,
  psutil,
  pyautogui,
  pydantic,
  pyperclip,
  pyyaml,
  rich,
  selenium,
  send2trash,
  setuptools,
  shortuuid,
  six,
  starlette,
  tiktoken,
  tokentrim,
  toml,
  typer,
  uvicorn,
  webdriver-manager,
  wget,
  yaspin,

  nltk,
}:

buildPythonPackage rec {
  pname = "open-interpreter";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KillianLucas";
    repo = "open-interpreter";
    tag = "v${version}";
    hash = "sha256-fogCcWAhcrCrrcV0q4oKttkf/GeJaJSZnbgiFxvySs8=";
  };

  pythonRemoveDeps = [ "git-python" ];

  pythonRelaxDeps = [
    "anthropic"
    "google-generativeai"
    "html2text"
    "psutil"
    "rich"
    "starlette"
    "tiktoken"
    "typer"
    "yaspin"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    anthropic
    astor
    fastapi
    google-generativeai
    html2image
    html2text
    inquirer
    ipykernel
    jupyter-client
    litellm
    matplotlib
    platformdirs
    psutil
    pyautogui
    pydantic
    pyperclip
    pyyaml
    rich
    selenium
    send2trash
    setuptools
    shortuuid
    six
    starlette
    tiktoken
    tokentrim
    toml
    typer
    uvicorn
    webdriver-manager
    wget
    yaspin

    # marked optional in pyproject.toml but still required?
    nltk
  ];

  pythonImportsCheck = [ "interpreter" ];

  # Most tests required network access
  doCheck = false;

  meta = {
    description = "OpenAI's Code Interpreter in your terminal, running locally";
    homepage = "https://github.com/KillianLucas/open-interpreter";
    license = lib.licenses.mit;
    changelog = "https://github.com/KillianLucas/open-interpreter/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "interpreter";
  };
}
