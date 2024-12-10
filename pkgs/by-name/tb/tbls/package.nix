{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  tbls,
}:

buildGoModule rec {
  pname = "tbls";
  version = "1.78.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    rev = "v${version}";
    hash = "sha256-vqt4IlVvqlUjDqvcdiRctt/VuEkZ5YzCXYHvHfc87Ew=";
  };

  vendorHash = "sha256-cnACY+NIjsVe6BU7AjTO+yLDn0f1HO1gHnw5SgqKuy4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  CGO_CFLAGS = [ "-Wno-format-security" ];

  preCheck = ''
    # Remove tests that require additional services.
    rm -f \
       datasource/*_test.go \
       drivers/*/*_test.go
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tbls \
      --bash <($out/bin/tbls completion bash) \
      --fish <($out/bin/tbls completion fish) \
      --zsh <($out/bin/tbls completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = tbls;
    command = "tbls version";
    inherit version;
  };

  meta = with lib; {
    description = "Tool to generate documentation based on a database structure";
    homepage = "https://github.com/k1LoW/tbls";
    changelog = "https://github.com/k1LoW/tbls/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    mainProgram = "tbls";
  };
}
