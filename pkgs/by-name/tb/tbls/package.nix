{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tbls";
  version = "1.93.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o/dBVUgNR8NSOo6bt9Z8yBG7S8oxNBMmQ1pRdEeKefI=";
  };

  vendorHash = "sha256-hR1YDdhF/YBaJdKioFLqQH7lqkEOPPwdPD6/GLl8hKc=";

  excludedPackages = [ "scripts/jsonschema" ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_CFLAGS = toString [ "-Wno-format-security" ];

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
    changelog = "https://github.com/k1LoW/tbls/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
    mainProgram = "tbls";
  };
})
