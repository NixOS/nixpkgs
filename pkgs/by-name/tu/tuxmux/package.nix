{ lib
, fetchFromGitHub
, rustPlatform
, libiconv
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "tuxmux";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "edeneast";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WtcEPvNC1GLOfX0ULUnGHtVO8CyHWQYAPCKwsUlKEzc=";
  };

  cargoHash = "sha256-OBaFBEsFjK7Mf2zqI60q6uSG5JnZiohQg79+Fm++tK4=";

  buildInputs = [ libiconv ];
  nativeBuildInputs = [ pkg-config installShellFiles ];

  postInstall = ''
    installShellCompletion $releaseDir/../completions/tux.{bash,fish}
    installShellCompletion --zsh $releaseDir/../completions/_tux

    installManPage $releaseDir/../man/*
  '';

  meta = with lib; {
    description = "Tmux session manager";
    homepage = "https://github.com/edeneast/tuxmux";
    license = licenses.asl20;
    maintainers = with maintainers; [ edeneast ];
    mainProgram = "tux";
  };
}
