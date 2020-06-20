{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, gtk2, xfce }:

let
  category = "panel-plugins";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  pname  = "xfce4-embed-plugin";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0a72kqsjjh45swimqlpyrahdnplp0383v0i4phr4n6g8c1ixyry7";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    gtk2
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-embed-plugin";
    description = "Embed arbitrary app windows on Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
