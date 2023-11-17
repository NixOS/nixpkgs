{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "tlrc";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-Jdie9ESSbRV07SHjITfQPwDKTedHMbY01FdEMlNOr50=";
  };

  cargoHash = "sha256-2OXyPtgdRGIIc7jIES9zhRpFiaodcEnaK88k+rUVSJo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage tldr.1

    installShellCompletion \
      --name tldr --bash $releaseDir/build/tlrc-*/out/tldr.bash \
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
