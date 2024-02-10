{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "tlrc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-wHAPlBNVhIytquEAUdrbxE4m0njVRPxxlYlwjqG9Zlw=";
  };

  cargoHash = "sha256-BymyjSVNwS3HPNnZcaAu1xUssV2iXmECtpKXPdZpM3g=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage tldr.1

    installShellCompletion --name tldr \
      --bash $releaseDir/build/tlrc-*/out/tldr.bash \
      --zsh $releaseDir/build/tlrc-*/out/_tldr \
      --fish $releaseDir/build/tlrc-*/out/tldr.fish
  '';

  meta = with lib; {
    description = "Official tldr client written in Rust";
    homepage = "https://github.com/tldr-pages/tlrc";
    changelog = "https://github.com/tldr-pages/tlrc/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "tldr";
    maintainers = with maintainers; [ acuteenvy ];
  };
}
