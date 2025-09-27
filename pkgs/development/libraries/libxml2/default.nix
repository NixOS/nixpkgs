{
  lib,
  callPackage,
  fetchFromGitLab,
  fetchpatch2,
}:

let
  packages = {
    libxml2_13 = callPackage ./common.nix {
      version = "2.13.8";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libxml2";
        tag = "v${packages.libxml2_13.version}";
        hash = "sha256-acemyYs1yRSTSLH7YCGxnQzrEDm8YPTK4HtisC36LsY=";
      };
      extraPatches = [
        # same as upstream patch but fixed conflict and added required import:
        # https://gitlab.gnome.org/GNOME/libxml2/-/commit/acbbeef9f5dcdcc901c5f3fa14d583ef8cfd22f0.diff
        ./CVE-2025-6021.patch
        (fetchpatch2 {
          name = "CVE-2025-49794-49796.patch";
          url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/f7ebc65f05bffded58d1e1b2138eb124c2e44f21.patch";
          hash = "sha256-k+IGq6pbv9EA7o+uDocEAUqIammEjLj27Z+2RF5EMrs=";
        })
        (fetchpatch2 {
          name = "CVE-2025-49795.patch";
          url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/c24909ba2601848825b49a60f988222da3019667.patch";
          hash = "sha256-r7PYKr5cDDNNMtM3ogNLsucPFTwP/uoC7McijyLl4kU=";
          excludes = [ "runtest.c" ]; # tests were rewritten in C and are on schematron for 2.13.x, meaning this does not apply
        })
        # same as upstream, fixed conflicts
        # https://gitlab.gnome.org/GNOME/libxml2/-/commit/c340e419505cf4bf1d9ed7019a87cc00ec200434
        ./CVE-2025-6170.patch
      ];
      freezeUpdateScript = true;
      extraMeta = {
        maintainers = with lib.maintainers; [
          gepbird
        ];
      };
    };
    libxml2 = callPackage ./common.nix {
      version = "2.14.6";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libxml2";
        tag = "v${packages.libxml2.version}";
        hash = "sha256-EIcNL5B/o74hyc1N+ShrlKsPL5tHhiGgkCR1D7FcDjw=";
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
