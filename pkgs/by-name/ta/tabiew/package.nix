{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  perl,
}:
rustPlatform.buildRustPackage rec {
  pname = "tabiew";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "shshemi";
    repo = "tabiew";
    tag = "v${version}";
    hash = "sha256-RvbHXnDaoqMHjA9u9kFs5MB6xeQG/E35PEu+1LIXIBU=";
  };

  cargoHash = "sha256-F+5Iy8eY5s+EfMqx4z4mh0SVoBwwnbM33c3yE7FUy4g=";

  nativeBuildInputs = [
    installShellFiles
    perl
  ];

  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    installManPage target/manual/tabiew.1

    installShellCompletion \
      --bash target/completion/tw.bash \
      --zsh target/completion/_tw \
      --fish target/completion/tw.fish
  '';

  doCheck = false; # there are no tests

  meta = {
    description = "Lightweight, terminal-based application to view and query delimiter separated value formatted documents, such as CSV and TSV files";
    homepage = "https://github.com/shshemi/tabiew";
    changelog = "https://github.com/shshemi/tabiew/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "tw";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
