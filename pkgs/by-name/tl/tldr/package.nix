{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "tldr";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tldr-python-client";
    tag = version;
    hash = "sha256-lc0Jen8vW4BNg784td1AZa2GTYvXC1d83FnAe5RZqpY=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    termcolor
    colorama
    shtab
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = with python3Packages; [
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    pytest -k 'not test_error_message'
    runHook postCheck
  '';

  doCheck = true;

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
    changelog = "https://github.com/tldr-pages/tldr-python-client/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      taeer
      carlosdagos
      kbdharun
    ];
    mainProgram = "tldr";
  };
}
