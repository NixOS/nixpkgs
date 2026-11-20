{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  openssl,
  pkg-config,
  sqlcipher,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tabiew";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "shshemi";
    repo = "tabiew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SUOOU/0zBrmQGcCqUqt1lqTQ00I+PbRNrb7UuOY62MI=";
  };

  cargoHash = "sha256-TWvLsvozAFVJuncjY7+wPPSa7cT716rjwyHxk7r4OI8=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlcipher
    zstd
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

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
    changelog = "https://github.com/shshemi/tabiew/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tw";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
