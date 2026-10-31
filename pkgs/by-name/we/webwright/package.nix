{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "webwright";
  version = "0.1.0-unstable-2026-05-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "Webwright";
    rev = "1236f4d31186610d23badd997917f86712fe8bed";
    hash = "sha256-aWLaY890Tu7NGGUTvZUW0S/qwNIxWrIhun4hcIY0nik=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    httpx
    jinja2
    pydantic
    pyyaml
    rich
    typer
    playwright
    python-dotenv
    platformdirs
  ];

  pythonImportsCheck = [ "webwright" ];

  preInstallCheck = ''
    # webwright/__init__.py creates a global config directory at import
    # time (`user_config_dir("mini-swe-webagent")` by default), which
    # fails in the Nix sandbox where HOME is /homeless-shelter.
    # MSWEBA_GLOBAL_CONFIG_DIR overrides that path.
    export MSWEBA_GLOBAL_CONFIG_DIR=$TMPDIR/webwright-config
  '';

  meta = {
    description = "SWE-style browser agent framework that turns coding models into web agents";
    longDescription = ''
      Webwright is a lightweight harness that gives an LLM a terminal in which
      it can launch and inspect Playwright-controlled browser sessions to
      complete long-horizon web tasks. The agent loop is intentionally minimal
      (~1.5k LoC across the core, the Playwright environment, and the CLI),
      with pluggable OpenAI / Anthropic / OpenRouter backends and no hidden
      orchestration layer.
    '';
    homepage = "https://github.com/microsoft/Webwright";
    changelog = "https://github.com/microsoft/Webwright/blob/main/README.md#-news";
    license = lib.licenses.mit;
    mainProgram = "webwright";
    maintainers = with lib.maintainers; [ conao3 ];
    platforms = lib.platforms.unix;
  };
}
