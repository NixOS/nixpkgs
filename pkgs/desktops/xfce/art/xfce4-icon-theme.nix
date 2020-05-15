{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gnome-icon-theme, tango-icon-theme, hicolor-icon-theme, xfce }:

let
  category = "art";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-icon-theme";
  version = "4.4.3";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "1yk6rx3zr9grm4jwpjvqdkl13pisy7qn1wm5cqzmd2kbsn96cy6l";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    gtk3
  ];

  buildInputs = [
    gnome-icon-theme
    tango-icon-theme
    hicolor-icon-theme
    # missing parent icon theme Industrial
  ];

  dontDropIconThemeCache = true;

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://www.xfce.org/";
    description = "Icons for Xfce";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}
