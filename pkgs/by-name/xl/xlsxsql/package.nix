{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "xlsxsql";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "xlsxsql";
    tag = "v${version}";
    hash = "sha256-OmNYrohWs4l7cReTBB6Ha9VuKPit1+P7a4QKhYwK5g8=";
  };

  vendorHash = "sha256-Zrt4NMoQePvipFyYpN+Ipgl2D6j/thCPhrQy4AbXOfQ=";

  ldflags = [
    "-X main.version=v${version}"
    "-X main.revision=${src.rev}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/xlsxsql"
        else
          lib.getExe buildPackages.xlsxsql;
    in
    ''
      installShellCompletion --cmd xlsxsql \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool that executes SQL queries on various files including xlsx files and outputs the results to various files";
    homepage = "https://github.com/noborus/xlsxsql";
    changelog = "https://github.com/noborus/xlsxsql/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "xlsxsql";
  };
}
