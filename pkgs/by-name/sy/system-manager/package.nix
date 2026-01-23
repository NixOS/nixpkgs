{
  lib,
  rustPlatform,
  fetchFromGitHub,
  dbus,
  pkg-config,
  clippy,
  nix,
  cargo,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "system-manager";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "system-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jjvn9gPmL6otZcaYjzE4cXLQFyzAEEsnpgwP3OoN8Gk=";
  };

  cargoHash = "sha256-A3A1RRx9U43u6wmzPE+yZwi08m7vcD5ccLC89TgDvOg=";

  buildInputs = [ dbus ];
  nativeBuildInputs = [
    pkg-config
  ];

  nativeCheckInputs = [
    clippy
    nix
    cargo
  ];

  preCheck = ''
    cargo clippy

    # Stop the Nix command from trying to create /nix/var/nix/profiles.
    #
    # https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-profile#profiles
    export NIX_STATE_DIR=$TMPDIR
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage system config using nix on any distro";
    homepage = "http://system-manager.net";
    license = lib.licenses.mit;
    mainProgram = "system-manager";
    maintainers = with lib.maintainers; [ jfroche ];
    platforms = lib.platforms.unix;
  };
})
