{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "9442dbf19c804cee1bd13a42ef83edaff5cd1b0a";
    hash = "sha256-87uXFIJyY6bcfOmyjpllj16fCVFc55YDzIeLToGOOUY=";
  };

  cargoHash = "sha256-wu8aqGMT2u8j52Y/foXD5gsLnqKgu8tPX6/dVzxHlPg=";

  cargoBuildFlags = [ "--package uu_hostname" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplementation of the hostname project";
    homepage = "https://github.com/uutils/hostname";
    license = lib.licenses.mit;
    mainProgram = "hostname";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
