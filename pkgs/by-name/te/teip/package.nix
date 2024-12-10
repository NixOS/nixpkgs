{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, perl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "teip";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "greymd";
    repo = "teip";
    rev = "v${version}";
    hash = "sha256-09IKAM1ha40CvF5hdQIlUab7EBBFourC70LAagrs5+4=";
  };

  cargoHash = "sha256-cBFczgvLja6upuPnXphG2d9Rf1ZpNAVh16NHAHfXxHg=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ perl ];

  # tests are locale sensitive
  preCheck = ''
    export LANG=${if stdenv.hostPlatform.isDarwin then "en_US.UTF-8" else "C.UTF-8"}
  '';

  postInstall = ''
    installManPage man/teip.1
    installShellCompletion \
      --bash completion/bash/teip \
      --fish completion/fish/teip.fish \
      --zsh completion/zsh/_teip
  '';

  meta = with lib; {
    description = "Tool to bypass a partial range of standard input to any command";
    mainProgram = "teip";
    homepage = "https://github.com/greymd/teip";
    changelog = "https://github.com/greymd/teip/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
