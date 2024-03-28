{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pythonRelaxDepsHook
, poetry-core

, appdirs
, astor
, inquirer
, litellm
, pyyaml
, rich
, six
, tiktoken
, tokentrim
, wget
, psutil
, html2image
, ipykernel
, jupyter-client
, matplotlib
, toml
, posthog
, openai
, setuptools
, fastapi
, nltk
, send2trash
, uvicorn
, aifs
}:

buildPythonPackage rec {
  pname = "open-interpreter";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "KillianLucas";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y8qFmj2CTNVmr6mACk4Q11VWOQysogyB4GmBuDlmWdk=";
  };

  # Remove unused dependency
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'git-python = "^1.0.3"' ""
  '';

  pythonRelaxDeps = [
    "tiktoken"
    "pydantic"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    astor
    # git-python is unused
    inquirer
    litellm
    pyyaml
    rich
    six
    tokentrim
    wget
    psutil
    html2image
    ipykernel
    jupyter-client
    matplotlib
    toml
    posthog
    tiktoken

    openai
    fastapi
    nltk
    send2trash
    uvicorn
    aifs

    appdirs

    # Not explicitly in pyproject.toml but required due to use of `pkgs_resources`
    setuptools
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
