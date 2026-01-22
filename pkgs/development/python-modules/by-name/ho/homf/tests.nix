{
  lib,
  runCommand,
  testers,

  cacert,
  homf,
}:
let
  # runs homf, putting the fetched artefacts in the drv output
  Homf =
    subcommand:
    {
      pkgName,
      version,
      hash,
    }:
    # testers.runCommand ensures we have an FOD, so the command has network access,
    #  yet the test is rerun whenever one of its inputs changes.
    testers.runCommand {
      name = "homf-${subcommand}-${pkgName}";
      script = "homf ${subcommand} --directory $out ${pkgName} ${version}";
      nativeBuildInputs = [
        cacert
        homf
      ];
      inherit hash;
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
