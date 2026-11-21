{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wechsel";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JustSomeRandomUsername";
    repo = "wechsel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2fPRH7SnSL5a6D6ktTiIZ3cCyUAnlckq3anoX5ftIgg=";
  };

  # Upstream does not ship a Cargo.lock; generated with `cargo generate-lockfile`
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # Tests are integration tests meant for upstream's Docker setup: they must
  # run as root (tests/utils.rs security_check) and invoke the binary via the
  # hardcoded path /workspace/target/release/wechsel
  doCheck = false;

  meta = {
    description = "Organize your computer by replacing user folders with symlinks to project folders";
    homepage = "https://github.com/JustSomeRandomUsername/wechsel";
    changelog = "https://github.com/JustSomeRandomUsername/wechsel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koppor ];
    mainProgram = "wechsel";
    platforms = lib.platforms.linux;
  };
})
