{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  installShellFiles,
  setuptools,
  gitpython,
  typer,
  pydantic-settings,
}:

buildPythonPackage rec {
  pname = "git-dummy";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "initialcommit-com";
    repo = "git-dummy";
    rev = "v${version}";
    hash = "sha256-viybxn2J7SO7NgSvjwlP+tgtm+H6QrACafIy82d9XEk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gitpython
    typer
    pydantic-settings
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    # https://github.com/NixOS/nixpkgs/issues/308283
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd git-dummy \
        --bash <($out/bin/git-dummy --show-completion bash) \
        --fish <($out/bin/git-dummy --show-completion fish) \
        --zsh <($out/bin/git-dummy --show-completion zsh)
    '';

  meta = {
    homepage = "https://github.com/initialcommit-com/git-dummy";
    description = "Generate dummy Git repositories populated with the desired number of commits, branches, and structure";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mathiassven ];
  };
}
