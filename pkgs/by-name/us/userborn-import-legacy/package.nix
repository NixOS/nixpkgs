{
  lib,
  rustPlatform,
  nixosTests,
}:

rustPlatform.buildRustPackage {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "userborn-import-legacy";
  version = (lib.importTOML ./Cargo.toml).package.version;

  src = builtins.filterSource (name: _: !(lib.hasSuffix ".nix" name)) ./.;

  cargoLock.lockFile = ./Cargo.lock;

  passthru.tests = { inherit (nixosTests) userborn-migration; };

  meta = {
    description = "One-shot migration from update-users-groups.pl state to userborn";
    longDescription = ''
      Runs once before userborn on systems that previously used the perl
      `update-users-groups.pl` script. It injects locked stub entries into
      /etc/{passwd,group,shadow} for every name recorded in
      /var/lib/nixos/{uid,gid}-map that no longer has a live entry, so a
      previously-used UID/GID cannot be reassigned to a different user, and
      synthesises previous-userborn.json from declarative-{users,groups}.

      This package is temporary and will be removed once the perl
      implementation has been dropped for two NixOS releases.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvdp ];
    platforms = lib.platforms.linux;
    mainProgram = "userborn-import-legacy";
  };
}
