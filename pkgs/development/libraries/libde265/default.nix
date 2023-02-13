{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config

# for passthru.tests
, imagemagick
, libheif
, imlib2Full
, gst_all_1
}:

stdenv.mkDerivation rec {
  version = "1.0.10";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    rev = "v${version}";
    sha256 = "sha256-d2TJKPvOAqLe+ZO1+Rd/yRIn3W1u1q62ZH20/9N2Shw=";
  };

  patches = [
    (fetchpatch {
      name = "revert-cmake-change-pkg-config.patch";
      url = "https://github.com/strukturag/libde265/commit/388b61459c2abe2b949114ab54e83fb4dbfa8ba0.patch";
      sha256 = "sha256-b6wwSvZpK7lIu0uD1SqK2zGBUjb/25+JW1Pf1fvHc0I=";
      revert = true;
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit imagemagick libheif imlib2Full;
    inherit (gst_all_1) gst-plugins-bad;
  };

  meta = {
    homepage = "https://github.com/strukturag/libde265";
    description = "Open h.265 video codec implementation";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
