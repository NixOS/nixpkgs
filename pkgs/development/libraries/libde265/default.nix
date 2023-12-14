{ lib
, stdenv
, fetchFromGitHub
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
  version = "1.0.14";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    rev = "refs/tags/v${version}";
    hash = "sha256-aZRtF4wYWxi/6ORNu7yVxFFdkvJTvBwPinL5lC0Mlqg=";
  };

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
