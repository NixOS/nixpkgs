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
  libliftoff_0_5 = mkVariant "0.5.0" "sha256-PcQY8OXPqfn8C30+GAYh0Z916ba5pik8U0fVpZtFb5g=";
}
