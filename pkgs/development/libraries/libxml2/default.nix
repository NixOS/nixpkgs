{
  lib,
  callPackage,
  fetchFromGitLab,
  fetchpatch,
}:

let
  packages = {
    libxml2_13 = callPackage ./common.nix {
      version = "2.13.9";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libxml2";
        tag = "v${packages.libxml2_13.version}";
        hash = "sha256-1qrgoMu702MglErNH9N2eCWFqxQnNHepR13m53GJb58=";
      };
      extraPatches = [
        # Unmerged ABI-breaking patch required to fix the following security issues:
        # - https://gitlab.gnome.org/GNOME/libxslt/-/issues/139
        # - https://gitlab.gnome.org/GNOME/libxslt/-/issues/140
        # See also https://gitlab.gnome.org/GNOME/libxml2/-/issues/906
        # Source: https://github.com/chromium/chromium/blob/4fb4ae8ce3daa399c3d8ca67f2dfb9deffcc7007/third_party/libxml/chromium/xml-attr-extra.patch
        ./xml-attr-extra.patch
      ];
      freezeUpdateScript = true;
      extraMeta = {
        maintainers = with lib.maintainers; [
          gepbird
        ];
      };
    };
    libxml2 = callPackage ./common.nix {
      version = "2.15.1";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libxml2";
        tag = "v${packages.libxml2.version}";
        hash = "sha256-FUfYMq5xT2i88JdIw9OtSofraUL3yjsyOVund+mfJKQ=";
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
