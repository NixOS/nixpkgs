{
  lib,
  callPackage,
  fetchFromGitLab,
}:

let
  packages = {
    libxml2 = callPackage ./common.nix {
      version = "2.14.5";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libxml2";
        tag = "v${packages.libxml2.version}";
        hash = "sha256-vxKlw8Kz+fgUP6bhWG2+4346WJVzqG0QvPG/BT7RftQ=";
      };
      extraMeta = {
        maintainers = with lib.maintainers; [
          jtojnar
        ];
      };
    };
  };
in
packages
