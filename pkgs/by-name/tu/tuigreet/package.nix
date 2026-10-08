{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  scdoc,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuigreet";
  version = "0.11.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tuigreet";
    repo = "tuigreet";
    tag = finalAttrs.version;
    hash = "sha256-nZkZY4ZlywDUbOWmDpj1ubjoiLQamYCwTV72N0Lgb8g=";
  };

  cargoHash = "sha256-5Q4E8nnmQ109gcfxxctn/rne5N4Qvz2Pft6o7as2fSc=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postInstall = ''
    scdoc < contrib/man/tuigreet-1.scd > tuigreet.1
    installManPage tuigreet.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical console greeter for greetd";
    homepage = "https://github.com/tuigreet/tuigreet";
    changelog = "https://github.com/tuigreet/tuigreet/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      NotAShelf
      antoineco
    ];
    platforms = lib.platforms.linux;
    mainProgram = "tuigreet";
  };
})
