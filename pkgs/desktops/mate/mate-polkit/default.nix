{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gobjectIntrospection, libappindicator-gtk3, libindicator-gtk3, polkit }:

stdenv.mkDerivation rec {
  name = "mate-polkit-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "01mxl7wj1501d3clrwlwa54970vpkahp5968xpaxwfb2zbnqgjbd";
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
