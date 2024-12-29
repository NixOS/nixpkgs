{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "tabiew";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "shshemi";
    repo = "tabiew";
    rev = "v${version}";
    hash = "sha256-WnIlGWfIoCq9jrMG9SI3zYFs6ItjrMFF6KiNYkiA9Ag=";
  };

  cargoHash = "sha256-lB6EaJnPoUxB+cs6rmiiOmgoOo+kzETRwKWbtsik42A=";

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
