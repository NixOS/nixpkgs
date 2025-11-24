{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "tbls";
  version = "1.91.3";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    tag = "v${version}";
    hash = "sha256-dmgWNdlGqI3kipNu9QEV8g3aArAgZb2qt5BkUhFNePk=";
  };

  vendorHash = "sha256-ppBzTerPhcM225VL6JzE4ZerTFqwnGmSxVTYyD3ur8o=";

  excludedPackages = [ "scripts/jsonschema" ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

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

  doInstallCheck = true;

  versionCheckProgramArg = "version";

  meta = {
    description = "Tool to generate documentation based on a database structure";
    homepage = "https://github.com/k1LoW/tbls";
    changelog = "https://github.com/k1LoW/tbls/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
    mainProgram = "tbls";
  };
}
