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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "edeneast";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HujdIT55NmXpHDa0a4EmB30va8bNdZ/MHu7+SwF9Nvc=";
  };

  cargoHash = "sha256-ceXeYa8MGGc0I8Q/r4GVsR71St/hlNc75a20BN0Haas=";

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
