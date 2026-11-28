{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-hostname";
  version = "0-unstable-2026-11-25";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "hostname";
    rev = "ba0c0b5023c396e5d2b271b91cd3fded772529c5";
    hash = "sha256-JOcJ51MCvgrrSzJD9N7TIv2xkrtOcWa1OO04CjRckh0=";
  };

  cargoHash = "sha256-DAGxOAtpc3kFEoumNCLnxnHtNWMVOnzijZ6Dk0fhvq8=";

  cargoBuildFlags = [ "--package=uu_hostname" ];

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
