{ lib
, stdenv
, fetchurl
, meson
, python3
, ninja
, fixedPoint ? false
, withCustomModes ? true
}:

stdenv.mkDerivation rec {
  pname = "libopus";
  version = "1.4";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/opus/opus-${version}.tar.gz";
    sha256 = "sha256-ybMrQlO+WuY9H/Fu6ga5S18PKVG3oCrO71jjo85JxR8=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    python3
    ninja
  ];

  mesonFlags = [
    (lib.mesonBool "fixed-point" fixedPoint)
    (lib.mesonBool "custom-modes" withCustomModes)
    (lib.mesonEnable "asm" stdenv.hostPlatform.isAarch)
    (lib.mesonEnable "docs" false)
  ];

  preBuild = ''
    patchShebangs meson/get-version.py
  '';

  doCheck = !stdenv.isi686 && !stdenv.isAarch32; # test_unit_LPC_inv_pred_gain fails

  meta = with lib; {
    description = "Open, royalty-free, highly versatile audio codec";
    homepage = "https://opus-codec.org/";
    changelog = "https://gitlab.xiph.org/xiph/opus/-/releases/v${version}";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
