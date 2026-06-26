{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "ycwd";
  version = "0-unstable-2026-05-10";

  src = fetchFromGitHub {
    owner = "blinry";
    repo = "ycwd";
    rev = "6e8b14be2ee1bf6194f69f9e127d21113656c345";
    hash = "sha256-7NwMeH2QWNOUna/Zu0RGcfLzX/103rN+3xqyQXx+62c=";
  };

  cargoHash = "sha256-gZpLBsS6b7l5EkPvn5CHqlwfZvKKLIZFMEC51T9GQFU=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Helps replace xcwd on Wayland compositors";
    homepage = "https://github.com/blinry/ycwd";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lenny ];
    mainProgram = "ycwd";
  };
}
