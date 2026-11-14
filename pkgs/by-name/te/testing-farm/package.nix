{
  lib,
  python3Packages,
  fetchFromGitLab,
  installShellFiles,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "testing-farm";
  version = "0.0.39";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "testing-farm";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LDkQlq4UPkUiX3ISUBCMRpF9EECNI0fz2U7otF/hLl0=";
  };

  build-system = [
    python3Packages.poetry-core
    python3Packages.poetry-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    click
    colorama
    cryptography
    dynaconf
    keyring
    pendulum
    python-dotenv
    requests
    rich
    ruamel-yaml
    shellingham
    typer
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  # Generate shell completion scripts with typer
  postInstall = ''
    gen_completion() {
      local shell="$1"
      ${python3Packages.python.interpreter} -c "
        import typer.completion
        print(typer.completion.get_completion_script(
          prog_name='testing-farm',
          complete_var='_TESTING_FARM_COMPLETE',
          shell='$shell'))
      "
    }

    installShellCompletion --cmd testing-farm \
      --bash <(gen_completion bash) \
      --fish <(gen_completion fish) \
      --zsh <(gen_completion zsh)
  '';

  pythonImportsCheck = [
    "tft.cli"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Testing Farm's CLI tool";
    homepage = "https://testing-farm.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ WOnder93 ];
    mainProgram = "testing-farm";
  };
})
