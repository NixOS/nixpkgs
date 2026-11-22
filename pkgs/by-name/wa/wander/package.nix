{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "wander";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = "wander";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PBeEb0WJFflhN/DzW5mqnqlvE8BWLEbqkZGfWSbFEFE=";
  };

  vendorHash = "sha256-0S8tzP5yNUrH6fp+v7nbUPTMWzYXyGw+ZNcXkSN+tWY=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wander \
      --fish <($out/bin/wander completion fish) \
      --bash <($out/bin/wander completion bash) \
      --zsh <($out/bin/wander completion zsh)
  '';

  meta = {
    description = "Terminal app/TUI for HashiCorp Nomad";
    license = lib.licenses.mit;
    homepage = "https://github.com/robinovitch61/wander";
    mainProgram = "wander";
  };
})
