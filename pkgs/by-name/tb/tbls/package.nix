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
  version = "1.86.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    tag = "v${version}";
    hash = "sha256-vV7eAjPrPlNNw+rLyrMe9G1KzVvtyFIOSrb+BrK3l00=";
  };

  vendorHash = "sha256-9IvnIFOlLdqmntisNomO5K6PU8gw7CSuEb46zG5ox2A=";

  excludedPackages = [ "scripts/jsonschema" ];

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

  meta = {
    description = "Tool to generate documentation based on a database structure";
    homepage = "https://github.com/k1LoW/tbls";
    changelog = "https://github.com/k1LoW/tbls/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
    mainProgram = "tbls";
  };
}
