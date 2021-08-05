{ runCommand, haskellPackages, lib, all-cabal-hashes, writeShellScript }:
let
  pkgLine = name: pkg:
    let
      version = pkg.version or "";
    in
    if version != "" then
      ''"${name}","${version}","http://hydra.nixos.org/job/nixpkgs/trunk/haskellPackages.${name}.x86_64-linux"''
    else "";
  all-haskellPackages = builtins.toFile "all-haskellPackages" (lib.concatStringsSep "\n" (lib.filter (x: x != "") (lib.mapAttrsToList pkgLine haskellPackages)));
in
runCommand "hackage-package-list" { }
  # This command will make a join between all packages on hackage and haskellPackages.*.
  # It creates a valid csv file which can be uploaded to hackage.haskell.org.
  # The call is wrapped in echo $(...) to trim trailing newline, which hackage requires.
  ''
    mkdir -p $out/bin
    echo -n "$(tar -t -f ${all-cabal-hashes} | sed 's![^/]*/\([^/]*\)/.*!"\1"!' | sort -u | join -t , - ${all-haskellPackages})" > $out/nixos-hackage-packages.csv
  ''
