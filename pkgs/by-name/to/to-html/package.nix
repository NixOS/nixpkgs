{
  lib,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  rustPlatform,
  unixtools,
  which,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.2.0";
  pname = "to-html";

  src = fetchFromGitHub {
    owner = "Aloso";
    repo = "to-html";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6gmctDk4zQgH0tyjVfUAFj6kGEe+0B44vEnQIyC7l9k=";
  };

  cargoHash = "sha256-r/gd8yjR7xgI0n7u+NvaoAD6ZHrGPoQ6RVnQlhYsCbI=";

  # Requires external resources
  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    installShellCompletion \
      $releaseDir/build/to-html-*/out/to-html.{bash,fish} \
      --zsh $releaseDir/build/to-html-*/out/_to-html

    wrapProgram $out/bin/to-html \
      --suffix PATH : ${
        lib.makeBinPath [
          unixtools.script
          which
        ]
      }
  '';

  meta = {
    description = "Terminal wrapper for rendering a terminal on a website by converting ANSI escape sequences to HTML";
    mainProgram = "to-html";
    homepage = "https://github.com/Aloso/to-html";
    changelog = "https://github.com/Aloso/to-html/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
})
