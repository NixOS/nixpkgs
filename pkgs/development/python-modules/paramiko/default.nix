{ callPackage }:

let
  mkParamiko = args: callPackage ./generic.nix args;
in
rec {
  paramiko_3 = mkParamiko {
    version = "3.5.1";
    hash = "sha256-ssZlvEWyshW9fX8DmQGxSwZ9oA86EeZkCZX9WPJmSCI=";
  };

  paramiko_5 = mkParamiko {
    version = "5.0.0";
    hash = "sha256-zzbM2oGaZ5jkIN7LyDGuMAKSpSmUwpBbup6MBVdTaXA=";
  };

  # Please make sure to update this alias to new major versions once they
  # build successfully on all major platforms.
  #
  # Packages that depend on paramiko should generally use this unversioned
  # alias.
  paramiko = paramiko_5;
}
