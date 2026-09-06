{
  lib,
  rustPlatform,
  fetchFromGitHub,
  dbus,
  pkg-config,
  clippy,
  nix,
  nixVersions,
  cargo,
  nix-update-script,
  writableTmpDirAsHomeHook,
  system-manager,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "system-manager";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "system-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r0/UDbEeYmVqhtxiuJSUfYhjBjtLKHDWhMScpe1RkOA=";
  };

  cargoHash = "sha256-oJWEP3wmINuhm7BGGRHPO81j4Zwll0OtyBF5WJ9+oQk=";

  buildInputs = [ dbus ];
  nativeBuildInputs = [
    pkg-config
  ];

  nativeCheckInputs = [
    clippy
    nix
    cargo
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    cargo clippy

    # Stop the Nix command from trying to create /nix/var/nix/profiles.
    #
    # https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-profile#profiles
    export NIX_STATE_DIR=$TMPDIR
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.latest-nix = system-manager.override { nix = nixVersions.latest; };
  };

  meta = {
    description = "Manage system config using nix on any distro";
    homepage = "http://system-manager.net";
    license = lib.licenses.mit;
    mainProgram = "system-manager";
    maintainers = with lib.maintainers; [
      jfroche
      picnoir
    ];
    platforms = lib.platforms.unix;
  };
})
