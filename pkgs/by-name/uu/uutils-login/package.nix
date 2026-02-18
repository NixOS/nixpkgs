{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "ac20bee6ad90261a6b506707c008e665b784647e";
    hash = "sha256-2is2UJSuHJsflcfrmJsSA5UFU6gLQ83cJSgvLiqjJBc=";
  };

  cargoHash = "sha256-SlVyUw7k4PFpyUHP8jlZaEaAgdqNgE2X/y7I/kP+GBs=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplemtation of the login project";
    homepage = "https://github.com/uutils/login";
    license = lib.licenses.mit;
    mainProgram = "shadow";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
