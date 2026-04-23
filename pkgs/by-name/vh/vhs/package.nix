{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  ffmpeg,
  ttyd,
  chromium,
  makeBinaryWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "vhs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "vhs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZnE5G8kfj7qScsT+bZg90ze4scpUxeC6xF8dAhdUUCo=";
  };

  vendorHash = "sha256-jmabOEFHduHzOBAymnxQrvYzXzxKnS1RqZZ0re3w63Y=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/vhs --prefix PATH : ${
      lib.makeBinPath (
        [
          ffmpeg
          ttyd
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ chromium ]
      )
    }
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/vhs man > vhs.1
    installManPage vhs.1
    installShellCompletion --cmd vhs \
      --bash <($out/bin/vhs completion bash) \
      --fish <($out/bin/vhs completion fish) \
      --zsh <($out/bin/vhs completion zsh)
  '';

  meta = {
    description = "Tool for generating terminal GIFs with code";
    mainProgram = "vhs";
    homepage = "https://github.com/charmbracelet/vhs";
    changelog = "https://github.com/charmbracelet/vhs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
