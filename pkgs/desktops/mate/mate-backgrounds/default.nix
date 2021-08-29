{ lib, stdenv, fetchurl, meson, ninja, gettext, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-backgrounds";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1ixb2vlm3dr52ibp4ggrbkf38m3q6i5lxjg4ix82gxbb6h6a3gp5";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Background images and data for MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus cc-by-sa-40 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
