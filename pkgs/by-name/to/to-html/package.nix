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
  version = "0.2.1";
  pname = "to-html";

  src = fetchFromGitHub {
    owner = "Aloso";
    repo = "to-html";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n20bKczitsyUeIBsHK5FGqbBOxXFZZHBYlpjQ7Yg+UM=";
  };

  cargoHash = "sha256-oGYNegMdG9C4TkqqEy7sXYcE+fmRP9lZBEu8IygGRgY=";

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
