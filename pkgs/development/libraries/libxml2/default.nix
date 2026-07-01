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

        (fetchpatch {
          name = "CVE-2026-0990.patch";
          url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/1961208e958ca22f80a0b4e4c9d71cfa050aa982.patch";
          hash = "sha256-Df2WLCTsP/ItSzgnVkNjRpLKkBP4xUOXEfCUV9o/Yks=";
        })

        # Based on https://gitlab.gnome.org/GNOME/libxml2/-/commit/f75abfcaa419a740a3191e56c60400f3ff18988d
        # Vendored, because there is no xmlCatalogPrintDebug in 2.13.9, use fprintf instead
        ./2.13-CVE-2026-0992.patch

        # Based on https://gitlab.gnome.org/GNOME/libxml2/-/commit/19549c61590c1873468c53e0026a2fbffae428ef.patch
        # There are only whitespace differences from upstream.
        ./2.13-CVE-2026-0989.patch
      ];
      freezeUpdateScript = true;
      extraMeta = {
        maintainers = with lib.maintainers; [
          gepbird
        ];
      };
    };
    libxml2 = callPackage ./common.nix {
      version = "2.15.3";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libxml2";
        tag = "v${packages.libxml2.version}";
        hash = "sha256-fDntZDyITs223by8n7ueOXiO7yyzshtANoWbY0+yeqo=";
      };
      extraPatches = [
        (fetchpatch {
          name = "CVE-2026-11979.patch";
          url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/c2e233fc1b341685fc99621b2768b503f777a72e.patch";
          hash = "sha256-s7hnAW7r4fbb95WnFHhUMZbMJzTynV7umKIqc7Kdp/Q=";
        })
      ];
      extraMeta = {
        maintainers = with lib.maintainers; [
          jtojnar
        ];
      };
    };
  };
in
packages
