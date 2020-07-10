{ buildDhallGitHubPackage, lib }:

let
  makeDhallKubernetes =
    version: { rev, sha256 }:
      buildDhallGitHubPackage {
        name  = "dhall-kubernetes-${version}";
        owner = "dhall-lang";
        repo  = "dhall-kubernetes";
        file  = "package.dhall";

        inherit rev sha256;
      };

in
  lib.mapAttrs makeDhallKubernetes {
    # 2.1.0 was the first version to introduce a top-level `package.dhall` file
    "2.1.0" = {
      rev    = "bbfec3d8548b605f1c9628f34029ab4a7d928839";
      sha256 = "10zkigj05khiy6w2sqcm5nw7d47r5k52xq8np8q86h0phy798g96";
    };

    "3.0.0" = {
      rev    = "3c6d09a9409977cdde58a091d76a6d20509ca4b0";
      sha256 = "1r4awh770ghsrwabh5ddy3jpmrbigakk0h32542n1kh71w3cdq1h";
    };
  }
