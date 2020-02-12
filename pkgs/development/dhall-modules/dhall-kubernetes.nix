{ buildDhallPackage, fetchFromGitHub, lib }:

let
  makeDhallKubernetes =
    version:
    lib.makeOverridable
      ( { rev
        , sha256

          # The version of the Kubernetes OpenAPI spec to use.
          #
          # This defaults to the latest supported Kubernetes if left unspecified.
          #
          # This is only supported by dhall-kubernetes version 3.0.0 or newer.
        , kubernetesVersion ? null

        , file ? "package.dhall"
        }:
          buildDhallPackage {
            name = "dhall-kubernetes-${version}";

            code =
              let
                src = fetchFromGitHub {
                  owner = "dhall-lang";

                  repo = "dhall-kubernetes";

                  inherit rev sha256;
                };

                prefix =
                  if kubernetesVersion == null then "" else "${kubernetesVersion}/";

              in
                "${src}/${prefix}${file}";
          }
      );

in
  lib.mapAttrs makeDhallKubernetes {
    # 2.1.0 was the first version to introduce a top-level `package.dhall` file
    "2.1.0" = {
      rev = "bbfec3d8548b605f1c9628f34029ab4a7d928839";

      sha256 = "10zkigj05khiy6w2sqcm5nw7d47r5k52xq8np8q86h0phy798g96";
    };

    "3.0.0" = {
      rev = "3c6d09a9409977cdde58a091d76a6d20509ca4b0";

      sha256 = "1r4awh770ghsrwabh5ddy3jpmrbigakk0h32542n1kh71w3cdq1h";
    };
  }
