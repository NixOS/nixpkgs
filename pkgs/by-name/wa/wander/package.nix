{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "wander";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1+bKdIAWdg/+5FBDbtvjDV0xpZ5jot3y6F+KuLO9WVk=";
  };

  vendorHash = "sha256-0S8tzP5yNUrH6fp+v7nbUPTMWzYXyGw+ZNcXkSN+tWY=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd wander \
      --fish <($out/bin/wander completion fish) \
      --bash <($out/bin/wander completion bash) \
      --zsh <($out/bin/wander completion zsh)
  '';

  meta = {
    description = "Terminal app/TUI for HashiCorp Nomad";
    license = lib.licenses.mit;
    homepage = "https://github.com/robinovitch61/wander";
    maintainers = lib.teams.c3d2.members;
    mainProgram = "wander";
  };
}
