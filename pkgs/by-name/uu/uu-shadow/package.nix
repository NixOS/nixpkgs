{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  libxcrypt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uu-shadow";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "shadow";
    tag = finalAttrs.version;
    hash = "sha256-VCtD1ni2tSjizN+SB6iX5Q6ppoW6f0c+msvW0XguOAc=";
  };

  cargoHash = "sha256-pN7I+jQDL+7B7lBnqF6TiVsmYbNWZnoeSeyKmY0GShk=";

  buildInputs = [ libxcrypt ];

  cargoBuildFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Memory-safe Rust reimplementation of Linux shadow-utils";
    homepage = "https://github.com/uutils/shadow";
    license = lib.licenses.mit;
    mainProgram = "shadow-rs";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.linux;
  };
})
