{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-login";
  version = "0-unstable-2026-02-04";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "login";
    rev = "18ca37671e817c80de264586840c75f30237f791";
    hash = "sha256-NvpMLaK5PTjw9/fdxu6Qj92jr0xS3Bbq935CPorYCTY=";
  };

  cargoHash = "sha256-onpSytr65iUN6sTSaJF+1AUr/GUNnhvnpcj1ksAylks=";

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
