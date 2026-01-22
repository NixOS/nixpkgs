{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  ffmpeg,
  ttyd,
  chromium,
  makeWrapper,
}:

buildGoModule rec {
  pname = "vhs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "vhs";
    rev = "v${version}";
    hash = "sha256-ZnE5G8kfj7qScsT+bZg90ze4scpUxeC6xF8dAhdUUCo=";
  };

  vendorHash = "sha256-jmabOEFHduHzOBAymnxQrvYzXzxKnS1RqZZ0re3w63Y=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/vhs --prefix PATH : ${
      lib.makeBinPath (
        lib.optionals stdenv.hostPlatform.isLinux [ chromium ]
        ++ [
          ffmpeg
          ttyd
        ]
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
    changelog = "https://github.com/charmbracelet/vhs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maaslalani ];
  };
}
