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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ceY4zLd+4EwXpwunKiWnaAB25qutSK1b1SyIriAbAI0=";
  };

  vendorHash = "sha256-2vRAI+Mm8Pzk3u4rndtwYnUlrAtjffe0kpoA1EHprQk=";

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
    $out/bin/vhs man > vhs.1
    installManPage vhs.1
    installShellCompletion --cmd vhs \
      --bash <($out/bin/vhs completion bash) \
      --fish <($out/bin/vhs completion fish) \
      --zsh <($out/bin/vhs completion zsh)
  '';

  meta = with lib; {
    description = "Tool for generating terminal GIFs with code";
    mainProgram = "vhs";
    homepage = "https://github.com/charmbracelet/vhs";
    changelog = "https://github.com/charmbracelet/vhs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      maaslalani
      penguwin
    ];
  };
}
