{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config

, callPackage

# for passthru.tests
, imagemagick
, libheif
, imlib2Full
, gst_all_1
}:

stdenv.mkDerivation (finalAttrs: rec {
  version = "1.0.11";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    rev = "v${version}";
    sha256 = "sha256-0aRUh5h49fnjBjy42A5fWYHnhnQ4CFoeSIXZilZewW8=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-27102.patch";
      url = "https://github.com/strukturag/libde265/commit/0b1752abff97cb542941d317a0d18aa50cb199b1.patch";
      sha256 = "sha256-q0NKuk2r5RQT9MJpRO3CTPj6VqYRBnffs9yZ+GM+lNc=";
    })
    (fetchpatch {
      name = "CVE-2023-27103.patch";
      url = "https://github.com/strukturag/libde265/commit/d6bf73e765b7a23627bfd7a8645c143fd9097995.patch";
      sha256 = "sha256-vxciVzSuVCVDpdz+TKg2tMWp2ArubYji5GLaR9VP4F0=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit imagemagick libheif imlib2Full;
    inherit (gst_all_1) gst-plugins-bad;

    test-corpus-decode = callPackage ./test-corpus-decode.nix {
      libde265 = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/strukturag/libde265";
    description = "Open h.265 video codec implementation";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gebner ];
  };
})
