{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "tuxmux";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "edeneast";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BZ1Vo1NIpzUBGyvd/UbxLaFbrLzoaP8kn/8GoAYBmlo=";
  };

  cargoHash = "sha256-HIYQPHLMhQtpCIkl5EzjJGHXzBtw7mY85l5bqapw3rg=";

  buildInputs = [ libiconv ];
  nativeBuildInputs = [ pkg-config installShellFiles ];

  postInstall = ''
    installShellCompletion $releaseDir/../completions/tm.{bash,fish}
    installShellCompletion --zsh $releaseDir/../completions/_tm

    installManPage $releaseDir/../man/*
  '';

  meta = with lib; {
    description = "Tmux session manager";
    homepage = "https://github.com/edeneast/tuxmux";
    license = licenses.asl20;
    maintainers = with maintainers; [ edeneast ];
    mainProgram = "tm";
  };
}
