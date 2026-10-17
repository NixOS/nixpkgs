{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termbg";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "termbg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JVRl0BCuU6duFcFZr3Rs8dgS+ikwCKe5/z3JgjAikiw=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "Program for terminal background color detection";
    homepage = "https://github.com/dalance/termbg";
    changelog = "https://github.com/dalance/termbg/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pinpox ];
    mainProgram = "termbg";
  };
})
