{
  lib,
  runCommand,
  testers,

  cacert,
  homf,
}:
let
  # A wrapper around `runCommand` which salts the drv so it's rebuilt if an input changes
  run = testers.invalidateFetcherByDrvHash (
    { name, command, ... }@args:
    runCommand name (lib.removeAttrs args [
      "name"
      "command"
    ]) command
  );

  # `run`s homf, putting the fetched artefacts in the drv output
  Homf =
    subcommand:
    {
      pkgName,
      version,
      hash,
    }:
    run {
      name = "homf-${subcommand}-${pkgName}";
      command = "homf ${subcommand} --directory $out ${pkgName} ${version}";
      nativeBuildInputs = [
        cacert
        homf
      ];
      outputHash = hash;
      outputHashMode = "recursive";
    };
in

lib.mapAttrs Homf {
  pypi = {
    pkgName = "homf";
    version = "1.1.1"; # pinned so updating homf won't invalidate hashes
    hash = "sha256-zpdt7+zTaGkLG6xYoTZVw/kUek0/MrCqvljfLxNB94A=";
  };

  github = {
    pkgName = "duckinator/homf";
    version = "v1.1.1";
    hash = "sha256-NeEz8wZqDWYUnrgsknXWHzhWdk8cPW8mknKS3+/dngQ=";
  };
}
