{ stdenv, fetchurl, meson, ninja, gettext }:

stdenv.mkDerivation rec {
  pname = "mate-backgrounds";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0b9yx68p9l867bqsl9z2g4wrs8p396ls673jgaliys5snmk8n8dn";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

  meta = with stdenv.lib; {
    description = "Background images and data for MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
