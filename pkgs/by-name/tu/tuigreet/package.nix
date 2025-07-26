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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = "tuigreet";
    tag = finalAttrs.version;
    hash = "sha256-e0YtpakEaaWdgu+bMr2VFoUc6+SUMFk4hYtSyk5aApY=";
  };

  cargoHash = "sha256-w6ZOqpwogKoN4oqqI1gFqY8xAnfvhEBVaL8/6JXpKXs=";

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
    homepage = "https://github.com/apognu/tuigreet";
    changelog = "https://github.com/apognu/tuigreet/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    mainProgram = "tuigreet";
  };
})
