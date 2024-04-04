{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config

, callPackage

  # for passthru.tests
, imagemagick
, libheif
, imlib2Full
, gst_all_1
}:

stdenv.mkDerivation (finalAttrs: rec {
  version = "1.0.15";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    rev = "refs/tags/v${version}";
    hash = "sha256-guiLM4RNe5O0qpeCoQUbs1Z7j0wp8iK9za2+6NIB8yY=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

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
    mainProgram = "dec265";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gebner ];
  };
})
