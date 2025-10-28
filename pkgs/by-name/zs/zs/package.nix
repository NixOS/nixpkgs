{
  lib,
  stdenv,
  fetchFromGitea,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "zs";
  version = "0.4.1";

  src = fetchFromGitea {
    domain = "git.mills.io";
    owner = "prologic";
    repo = "zs";
    rev = version;
    hash = "sha256-V8+p19kvVh64yCreNVp4RVdkJkjrq8Q5VbjaJWekZHY=";
  };

  vendorHash = "sha256-KXcYTYO4wnWOup5uJ6T+XwthX5l2FL02JyOt1Nv51Sg=";

  ldflags = [
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Commit=${src.rev}"
    "-X=main.Build=1970-01-01T00:00:00+00:00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zs \
      --bash <($out/bin/zs completion bash) \
      --fish <($out/bin/zs completion fish) \
      --zsh <($out/bin/zs completion zsh)
  '';

  meta = {
    description = "Extremely minimal static site generator written in Go";
    homepage = "https://git.mills.io/prologic/zs";
    changelog = "https://git.mills.io/prologic/zs/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adtya ];
    mainProgram = "zs";
  };
}
