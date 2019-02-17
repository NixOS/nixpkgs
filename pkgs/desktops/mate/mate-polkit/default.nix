{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gobject-introspection, libappindicator-gtk3, libindicator-gtk3, polkit, mate }:

stdenv.mkDerivation rec {
  name = "mate-polkit-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0zajisavrxiynmp4qg7zamvkpnhy9nra01czwn21h6hm2yakbayr";
  };

  nativeBuildInputs = [
    gobject-introspection
    intltool
    pkgconfig
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
    libindicator-gtk3
    polkit
  ];

  meta = with stdenv.lib; {
    description = "Integrates polkit authentication for MATE desktop";
    homepage = http://mate-desktop.org;
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
