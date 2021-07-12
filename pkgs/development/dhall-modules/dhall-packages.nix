{ buildDhallGitHubPackage, dhall-kubernetes, Prelude }:

let
  Prelude_12_0_0 = Prelude.overridePackage {
    name = "Prelude-12.0.0";
    rev    = "9f248138f69ee5e22192dc3d0417d5c77b189e04";
    sha256 = "1gbr0376sfamp0ibhcbxz4vaxr6ipv42y42p5wyksfhz3ls9x5ph";
  };

  kubernetes = {
    "6a47bd" = dhall-kubernetes.overridePackage {
      name   = "dhall-kubernetes-6a47bd";
      rev    = "6a47bd50c4d3984a13570ea62382a3ad4a9919a4";
      sha256 = "1azqs0x2kia3xw93rfk2mdi8izd7gy9aq6qzbip32gin7dncmfhh";
    };

    "4ad581" = dhall-kubernetes.overridePackage {
      name   = "dhall-kubernetes-4ad581";
      rev    = "4ad58156b7fdbbb6da0543d8b314df899feca077";
      sha256 = "12fm70qbhcainxia388svsay2cfg9iksc6mss0nvhgxhpypgp8r0";
    };

    "fee24c" = dhall-kubernetes.overridePackage {
      name   = "dhall-kubernetes-fee24c";
      rev    = "fee24c0993ba0b20190e2fdb94e386b7fb67252d";
      sha256 = "11d93z8y0jzrb8dl43gqha9z96nxxqkl7cbxpz8hw8ky9x6ggayk";
    };
  };

in
  buildDhallGitHubPackage {
    name   = "dhall-packages-0.11.1";
    owner  = "EarnestResearch";
    repo   = "dhall-packages";
    file   = "package.dhall";
    rev    = "8d228f578fbc7bb16c04a7c9ac8c6c7d2e13d1f7";
    sha256 = "1v4y1x13lxy6cxf8xqc6sb0mc4mrd4frkxih95v9q2wxw4vkw2h7";

    dependencies = [
      (kubernetes."6a47bd".overridePackage { file = "1.14/package.dhall"; })
      (kubernetes."6a47bd".overridePackage { file = "1.15/package.dhall"; })
      (kubernetes."6a47bd".overridePackage { file = "1.16/package.dhall"; })
      (kubernetes."4ad581".overridePackage { file = "types.dhall"; })
      (kubernetes."fee24c".overridePackage { file = "types/io.k8s.api.core.v1.ServiceSpec.dhall"; })
      (kubernetes."fee24c".overridePackage { file = "types/io.k8s.api.core.v1.PodTemplateSpec.dhall"; })
      Prelude_12_0_0
      (Prelude_12_0_0.overridePackage { file = "JSON/package.dhall"; })
      (Prelude_12_0_0.overridePackage { file = "JSON/Type"; })
      (Prelude_12_0_0.overridePackage { file = "Map/Type"; })
    ];
  }
