{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  perl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tabiew";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "shshemi";
    repo = "tabiew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gZIPeN7DSOyKf5RGo5ZP+dR4ke8NabVdT0ekQl9DvUM=";
  };

  cargoHash = "sha256-GEAKJECs98WUxJHD5FDmVafplPl7Yj7NGBL0zNRLhak=";

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
    changelog = "https://github.com/shshemi/tabiew/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tw";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
