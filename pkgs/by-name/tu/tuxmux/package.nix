{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  pkg-config,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuxmux";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "edeneast";
    repo = "tuxmux";
    rev = "v${version}";
    hash = "sha256-WcHsFKpYexBEg382837NqGgNMTKzVUG3XIER9aa1zK8=";
  };

  cargoHash = "sha256-ceEF9ySxcU9vVZdNIogSiHbN/xYjudAoohy7jyeKrBU=";

  buildInputs = [ libiconv ];
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

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
