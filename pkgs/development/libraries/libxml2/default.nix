{
  lib,
  callPackage,
  fetchurl,
  fetchFromGitLab,
}:

let
  packages = {
    libxml2_2_13 = callPackage ./common.nix {
      version = "2.13.8";
      src = fetchurl {
        url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor packages.libxml2_2_13.version}/libxml2-${packages.libxml2_2_13.version}.tar.xz";
        hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
      };
      extraMeta = {
        knownVulnerabilities = [
          "CVE-2025-6021"
        ];
        maintainers = with lib.maintainers; [
          gepbird
        ];
      };
    };
    libxml2 = callPackage ./common.nix {
      version = "2.14.4-unstable-2025-06-20";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libxml2";
        rev = "356542324fa439de544b5e419b91ae68d42c306c"; # some bugfixes right behind 2.14.4
        hash = "sha256-0jo08ECX+oP7Ekjgw3ZgOh+fSiNjlbjoZc4p3PqomJA=";
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
