{
  lib,
  python3Packages,
  versionCheckHook,
  fetchPypi,
  installShellFiles,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zmk-cli";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "zmk";
    inherit (finalAttrs) version;
    hash = "sha256-vRpzNPW4j6g1N9ZKVBEF6e7Ohwbx/+HrpI4GpyFDVzg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
    installShellFiles
  ];

  dependencies = with python3Packages; [
    dacite
    giturlparse
    mako
    rich
    ruamel-yaml
    shellingham
    typer
    west
  ];

  # nixpkgs dependencies are too fresh but seem to work just fine
  pythonRelaxDeps = true;

  postPatch = ''
    cat ./zmk/repo.py
    substituteInPlace ./zmk/repo.py --replace-fail \
      '[sys.executable, "-m", "west", *args]' \
      '["${python3Packages.west}/bin/west", *args]'
  '';

  postInstall = ''
    installShellCompletion --cmd zmk \
      --bash <(_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1 $out/bin/zmk --show-completion bash) \
      --zsh <(_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1 $out/bin/zmk --show-completion zsh) \
      --fish <(_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1 $out/bin/zmk --show-completion fish)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "zmk";
    description = "Command line tool for ZMK Firmware";
    homepage = "https://zmk.dev/docs/zmk-cli";
    changelog = "https://github.com/zmkfirmware/zmk-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
