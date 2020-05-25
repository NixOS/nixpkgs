{ buildDhallPackage, dhall-kubernetes, fetchFromGitHub, lib, Prelude }:

let
  makeDhallPackages =
    version:
    lib.makeOverridable
      ( { rev
        , sha256
        , dependencies
        }:
          buildDhallPackage {
            name = "dhall-packages-${version}";

            inherit dependencies;

            code =
              let
                src = fetchFromGitHub {
                  owner = "EarnestResearch";
                  repo  = "dhall-packages";

                  inherit rev sha256;
                };

              in
                "${src}/package.dhall";
          }
      );

in
  lib.mapAttrs makeDhallPackages {
    "0.11.1" =
      let
        k8s_6a47bd = dhall-kubernetes."3.0.0".override {
          rev    = "6a47bd50c4d3984a13570ea62382a3ad4a9919a4";
          sha256 = "1azqs0x2kia3xw93rfk2mdi8izd7gy9aq6qzbip32gin7dncmfhh";
        };

        k8s_4ad581 = dhall-kubernetes."3.0.0".override {
          rev    = "4ad58156b7fdbbb6da0543d8b314df899feca077";
          sha256 = "12fm70qbhcainxia388svsay2cfg9iksc6mss0nvhgxhpypgp8r0";
        };

        k8s_fee24c = dhall-kubernetes."3.0.0".override {
          rev    = "fee24c0993ba0b20190e2fdb94e386b7fb67252d";
          sha256 = "11d93z8y0jzrb8dl43gqha9z96nxxqkl7cbxpz8hw8ky9x6ggayk";
        };

      in
        { rev    = "8d228f578fbc7bb16c04a7c9ac8c6c7d2e13d1f7";
          sha256 = "1v4y1x13lxy6cxf8xqc6sb0mc4mrd4frkxih95v9q2wxw4vkw2h7";

          dependencies = [
            (k8s_6a47bd.override { file = "1.14/package.dhall"; })
            (k8s_6a47bd.override { file = "1.15/package.dhall"; })
            (k8s_6a47bd.override { file = "1.16/package.dhall"; })
            (k8s_4ad581.override { file = "types.dhall"; })
            (k8s_fee24c.override { file = "types/io.k8s.api.core.v1.ServiceSpec.dhall"; })
            (k8s_fee24c.override { file = "types/io.k8s.api.core.v1.PodTemplateSpec.dhall"; })
            Prelude."12.0.0"
            (Prelude."12.0.0".override { file = "JSON/package.dhall"; })
            (Prelude."12.0.0".override { file = "JSON/Type"; })
            (Prelude."12.0.0".override { file = "Map/Type"; })
          ];
        };
  }
