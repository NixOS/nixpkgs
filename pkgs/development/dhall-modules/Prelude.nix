{ buildDhallPackage, fetchFromGitHub, lib }:

let
  makePrelude =
    version:
    lib.makeOverridable
      ( { rev, sha256, file ? "package.dhall" }:
          buildDhallPackage {
            name = "Prelude-${version}";

            code =
              let
                src = fetchFromGitHub {
                  owner = "dhall-lang";
                  repo  = "dhall-lang";

                  inherit rev sha256;
                };

              in
                "${src}/Prelude/${file}";
          }
      );

in
  lib.mapAttrs makePrelude {
    # Prelude versions older than 7.0.0 use old-style union literals, which are
    # no longer supported by the latest version of the standard
    "7.0.0" = {
      rev    = "f0509b403ace4b8a72ebb5fa9c473b9aeabeaf33";
      sha256 = "00ldlvqfh411vnrnc41zfnlvgfanwfd3l8hdia8kni3r8q9qmd71";
    };

    "8.0.0" = {
      rev    = "136a3491753fef251b2087031617d1ee1053f285";
      sha256 = "0haxd5dhi5bmg06a0hx1blpivmwrcnndydwagibj3zvch4knyi2q";
    };

    "9.0.0" = {
      rev    = "6cbf57c946e7e6576babc23a38320e53ecfa6bee";
      sha256 = "1r06fijszyifq5b4j6libwkm06g8693m9n5c4kq61dvzrjfd2gim";
    };

    "10.0.0" = {
      rev    = "ecbf82785cff406bbd162bbabf3df6f817c805e0";
      sha256 = "0gxkr9649jqpykdzqjc98gkwnjry8wp469037brfghyidwsm021m";
    };

    "11.0.0" = {
      rev    = "8098184d17c3aecc82674a7b874077a7641be05a";
      sha256 = "0rdvyxq7mvas82wsfzzpk6imzm8ax4q58l522mx0ks69pacpr3yi";
    };

    "11.1.0" = {
      rev    = "31e90e1996f6c4cb50e03ccb1f3c45beb4bd278c";
      sha256 = "0rdvyxq7mvas82wsfzzpk6imzm8ax4q58l522mx0ks69pacpr3yi";
    };

    "12.0.0" = {
      rev    = "9f248138f69ee5e22192dc3d0417d5c77b189e04";
      sha256 = "1gbr0376sfamp0ibhcbxz4vaxr6ipv42y42p5wyksfhz3ls9x5ph";
    };

    "13.0.0" = {
      rev    = "48db9e1ff1f8881fa4310085834fbc19e313ebf0";
      sha256 = "0kg3rzag3irlcldck63rjspls614bc2sbs3zq44h0pzcz9v7z5h9";
    };
  }
