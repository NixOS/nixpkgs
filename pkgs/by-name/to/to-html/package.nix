{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  version = "0.1.6";
  pname = "to-html";

  src = fetchFromGitHub {
    owner = "Aloso";
    repo = "to-html";
    rev = "v${version}";
    hash = "sha256-eNFt9/yK4oHOspNM8PMTewhx8APaHzmgNdrWqrUuQSU=";
  };

  cargoHash = "sha256-EeR0nzTKQ4fB/tXuPIWokSNBQIthGpxSySsASo74A/A=";

  # Requires external resources
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      $releaseDir/build/to-html-*/out/to-html.{bash,fish} \
      --zsh $releaseDir/build/to-html-*/out/_to-html
  '';

  meta = {
    description = "Terminal wrapper for rendering a terminal on a website by converting ANSI escape sequences to HTML";
    mainProgram = "to-html";
    homepage = "https://github.com/Aloso/to-html";
    changelog = "https://github.com/Aloso/to-html/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
}
