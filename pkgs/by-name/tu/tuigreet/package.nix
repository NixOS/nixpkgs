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
  version = "0.11.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tuigreet";
    repo = "tuigreet";
    tag = finalAttrs.version;
    hash = "sha256-zBuauiyIc/Z9QKFkx8m/3sro0vRy/Glrqx2gD7wtfhY=";
  };

  cargoHash = "sha256-pH2Chqa7Pl9Oj+9YcwXtK21EUvSF7rp7lmT12Vg8ud4=";

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
