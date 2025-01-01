{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  poetry-core,

  setuptools,
  astor,
  inquirer,
  pyyaml,
  rich,
  six,
  tokentrim,
  wget,
  psutil,
  html2image,
  send2trash,
  ipykernel,
  jupyter-client,
  matplotlib,
  toml,
  tiktoken,
  platformdirs,
  pydantic,
  google-generativeai,
  pynput,
  pyperclip,
  yaspin,
  shortuuid,
  litellm,

  nltk,
}:

buildPythonPackage rec {
  pname = "open-interpreter";
  version = "0.3.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "KillianLucas";
    repo = "open-interpreter";
    rev = "v${version}";
    hash = "sha256-TeBiRylrq5CrAG9XS47Z9GlruAv7V7Nsl4QbSV55isM=";
  };

  pythonRemoveDeps = [ "git-python" ];

  pythonRelaxDeps = [
    "google-generativeai"
    "psutil"
    "pynput"
    "yaspin"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    setuptools
    astor
    inquirer
    pyyaml
    rich
    six
    tokentrim
    wget
    psutil
    html2image
    send2trash
    ipykernel
    jupyter-client
    matplotlib
    toml
    tiktoken
    platformdirs
    pydantic
    google-generativeai
    pynput
    pyperclip
    yaspin
    shortuuid
    litellm

    # marked optional in pyproject.toml but still required?
    nltk
  ];

  pythonImportsCheck = [ "interpreter" ];

  # Most tests required network access
  doCheck = false;

  meta = with lib; {
    description = "OpenAI's Code Interpreter in your terminal, running locally";
    homepage = "https://github.com/KillianLucas/open-interpreter";
    license = licenses.mit;
    changelog = "https://github.com/KillianLucas/open-interpreter/releases/tag/v${version}";
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "interpreter";
  };
}
