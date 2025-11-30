{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tydra";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "tydra";
    rev = "v${version}";
    sha256 = "sha256-bH/W54b7UHdkbgLXAd+l5I6UAKjWDMW+I5mfwT4yEEY=";
  };

  cargoHash = "sha256-sFNrpddhsqxy7HtCXV78oacyNzrTeM0rUcL7qgeJTcM=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/{tydra.1,tydra-actions.5}

    $out/bin/tydra --generate-completions bash > tydra.bash
    $out/bin/tydra --generate-completions fish > tydra.fish
    $out/bin/tydra --generate-completions zsh > _tydra

    installShellCompletion tydra.{bash,fish} _tydra
  '';

  meta = with lib; {
    description = "Shortcut menu-based task runner, inspired by Emacs Hydra";
    homepage = "https://github.com/Mange/tydra";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "tydra";
  };
}
