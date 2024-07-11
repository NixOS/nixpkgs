{ lib, fetchFromGitHub, rustPlatform, stdenv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tabiew";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "shshemi";
    repo = "tabiew";
    rev = "v${version}";
    hash = "sha256-sJQlvJxVXHgkE4RUtlM3BNL1rZKvQa7C5wlPHjFSuus=";
  };

  cargoHash = "sha256-QpeCGeId6pPYSGQvcI06zFC013RLcv7ryZlEn3F9dAI=";

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "man" ];

  postInstall = ''
    installManPage target/manual/tabiew.1

    installShellCompletion \
      --bash target/completion/tw.bash \
      --zsh target/completion/_tw \
      --fish target/completion/tw.fish
  '';

  doCheck = false; # there are no tests

  meta = {
    description =
      "Lightweight, terminal-based application to view and query delimiter separated value formatted documents, such as CSV and TSV files";
    homepage = "https://github.com/shshemi/tabiew";
    changelog = "https://github.com/shshemi/tabiew/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "tw";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
