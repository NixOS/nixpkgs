{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tldr";
  version = "3.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tldr-python-client";
    tag = finalAttrs.version;
    hash = "sha256-YdVmgV7N67XswcGlUN1hhXpRXGMHhY34VBxfr7i/MBs=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    termcolor
    shtab
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    # Requires internet access
    "test_error_message"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tldr \
      --bash <($out/bin/tldr --print-completion bash | sed -E "s#\"/nix/store/[^\"]+/bin/python[^\"]*\" -m tldr#\"$out/bin/tldr\"#g") \
      --zsh <($out/bin/tldr --print-completion zsh | sed -E "s#\"/nix/store/[^\"]+/bin/python[^\"]*\" -m tldr#\"$out/bin/tldr\"#g") \
  '';

  meta = {
    description = "Simplified and community-driven man pages";
    longDescription = ''
      tldr pages gives common use cases for commands, so you don't need to hunt
      through a man page for the correct flags.
    '';
    homepage = "https://tldr.sh";
    changelog = "https://github.com/tldr-pages/tldr-python-client/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      taeer
      carlosdagos
      kbdharun
    ];
    mainProgram = "tldr";
  };
})
