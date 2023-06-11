{ lib
, stdenv
, fetchpatch
, fetchurl
, meson
, python3
, ninja
, fixedPoint ? false
, withCustomModes ? true

# tests
, ffmpeg-headless
}:

stdenv.mkDerivation rec {
  pname = "libopus";
  version = "1.4";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/opus/opus-${version}.tar.gz";
    sha256 = "sha256-ybMrQlO+WuY9H/Fu6ga5S18PKVG3oCrO71jjo85JxR8=";
  };

  patches = [
    ./fix-pkg-config-paths.patch
    # Fix meson build for arm64. Remove with next release
    # https://gitlab.xiph.org/xiph/opus/-/merge_requests/59
    (fetchpatch {
      url = "https://gitlab.xiph.org/xiph/opus/-/commit/20c032d27c59d65b19b8ffbb2608e5282fe817eb.patch";
      hash = "sha256-2pX+0ay5PTyHL2plameBX2L1Q4aTx7V7RGiTdhNIuE4=";
    })
  ];

  postPatch = ''
    patchShebangs meson/
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    python3
    ninja
  ];

  mesonFlags = [
    (lib.mesonBool "fixed-point" fixedPoint)
    (lib.mesonBool "custom-modes" withCustomModes)
    (lib.mesonEnable "asm" false)
    (lib.mesonEnable "docs" false)
  ];

  doCheck = !stdenv.isi686 && !stdenv.isAarch32; # test_unit_LPC_inv_pred_gain fails

  passthru.tests = {
    inherit ffmpeg-headless;
  };

  meta = with lib; {
    description = "Open, royalty-free, highly versatile audio codec";
    homepage = "https://opus-codec.org/";
    changelog = "https://gitlab.xiph.org/xiph/opus/-/releases/v${version}";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
