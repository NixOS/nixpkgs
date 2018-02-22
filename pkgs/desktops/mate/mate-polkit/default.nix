{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gobjectIntrospection, libappindicator-gtk3, libindicator-gtk3, polkit, mate }:

stdenv.mkDerivation rec {
  name = "mate-polkit-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "00c1rmi31gv1a3lk7smjp489kd3wrj0d6npagnb8p1rz0g88ha94";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    gtk3
    gobjectIntrospection
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
