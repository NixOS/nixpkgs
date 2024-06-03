{ callPackage, fetchFromGitLab, ... }:
let
  mkVariant =
    version: hash:
    callPackage ./generic.nix {
      inherit version;
      src = fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "emersion";
        repo = "libliftoff";
        rev = "v${version}";
        inherit hash;
      };
    };
in
{
  libliftoff_0_4 = mkVariant "0.4.1" "sha256-NPwhsd6IOQ0XxNQQNdaaM4kmwoLftokV86WYhoa5csY=";
}
