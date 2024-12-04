{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "tabiew";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "shshemi";
    repo = "tabiew";
    rev = "v${version}";
    hash = "sha256-c7Oo0sr/9uvOYwtNRTyYNWYVaBUWJXwJmMXaivv4RTg=";
  };

  cargoHash = "sha256-uGxqVA7LrO0bzYVCDaPt4yECxWEzV4PQxxvk+17IX4w=";

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
