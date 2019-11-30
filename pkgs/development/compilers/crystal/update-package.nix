{ lib, crystal, writeShellScript, makeWrapper, crystal2nix, nix-prefetch-github, shards, git }:
let
  update = crystal.buildCrystalPackage {
    name = "update-crystal-package";
    version = "0.0.1";
    unpackPhase = ''
      cp ${./update-package.cr} update-package.cr
    '';
    buildInputs = [ makeWrapper ];
    crystalBinaries.update-crystal-package.src = "update-package.cr";

    postInstall = ''
      wrapProgram $out/bin/update-crystal-package --prefix PATH : ${lib.makeBinPath [
        nix-prefetch-github crystal2nix shards git
      ]}
    '';
  };
in { owner, repo }:
writeShellScript "update-crystal-package.sh" ''
  ${update}/bin/update-crystal-package ${owner} ${repo}
''
