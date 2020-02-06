{ lib, crystal, nix-prefetch-git }:
crystal.buildCrystalPackage {
  pname = "crystal2nix";
  version = "unstable-2018-07-31";

  nixPrefetchGit = "${lib.getBin nix-prefetch-git}/bin/nix-prefetch-git";
  unpackPhase = "substituteAll ${./crystal2nix.cr} crystal2nix.cr";

  crystalBinaries.crystal2nix.src = "crystal2nix.cr";

  meta = with lib; {
    description = "Utility to convert Crystal's shard.lock files to a Nix file";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
  };
}
