{
  runCommand,
  haskellPackages,
  lib,
  all-cabal-hashes,
}:
let
  # Checks if the version looks like a Haskell PVP version which is the format
  # Hackage enforces. This will return false if the version strings is empty or
  # we've overridden the package to ship an unstable version of the package
  # (sadly there's no good way to show something useful on hackage in this case).
  isPvpVersion = v: builtins.match "([0-9]+)(\\.[0-9]+)*" v != null;

  pkgLine =
    name: pkg:
    let
      version = pkg.version or "";
    in
    lib.optionalString (isPvpVersion version && (pkg.meta.hydraPlatforms or null) != lib.platforms.none)
      ''"${name}","${version}","http://hydra.nixos.org/job/nixpkgs/trunk/haskellPackages.${name}.x86_64-linux"'';
  all-haskellPackages = builtins.toFile "all-haskellPackages" (
    lib.concatStringsSep "\n" (lib.filter (x: x != "") (lib.mapAttrsToList pkgLine haskellPackages))
  );
in
runCommand "hackage-package-list" { }
  # This command will make a join between all packages on hackage and haskellPackages.*.
  # It ignores packages marked as broken (according to hydraPlatforms)
  # It creates a valid csv file which can be uploaded to hackage.haskell.org.
  # The call is wrapped in echo $(...) to trim trailing newline, which hackage requires.
  ''
    mkdir -p $out/bin
    echo -n "$(tar -t -f ${all-cabal-hashes} | sed 's![^/]*/\([^/]*\)/.*!"\1"!' | sort -u | join -t , - ${all-haskellPackages})" > $out/nixos-hackage-packages.csv
  ''
