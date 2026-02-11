{
  lib,
  fetchPypi,
  installShellFiles,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tmuxp";
  version = "1.56.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-6Nc6JHNZM6OUgoOfpD4wCDUlLAb2kLBplm1IjuVG/q8=";
  };

  build-system = with python3Packages; [
    hatchling
    shtab
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    colorama
    libtmux
    pyyaml
  ];

  # No tests in archive
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd tmuxp \
      --bash <(shtab --shell=bash -u tmuxp.cli.create_parser) \
      --zsh <(shtab --shell=zsh -u tmuxp.cli.create_parser)
  '';

  meta = {
    description = "tmux session manager";
    homepage = "https://tmuxp.git-pull.com/";
    changelog = "https://github.com/tmux-python/tmuxp/raw/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "tmuxp";
  };
})
