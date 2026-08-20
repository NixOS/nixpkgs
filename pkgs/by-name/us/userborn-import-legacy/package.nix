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
      Runs once before userborn on systems migrating from
      update-users-groups.pl. Adds locked stub entries to
      /etc/{passwd,group,shadow} for every name in
      /var/lib/nixos/{uid,gid}-map without a live entry so freed ids are
      not reassigned, and creates previous-userborn.json based on
      declarative-{users,groups}.

      Temporary. Will be removed once the perl implementation has been
      gone for two NixOS releases.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvdp ];
    platforms = lib.platforms.linux;
    mainProgram = "userborn-import-legacy";
  };
}
