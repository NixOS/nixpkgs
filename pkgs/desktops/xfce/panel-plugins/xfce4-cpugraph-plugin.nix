{ stdenv, fetchurl, pkgconfig, intltool, glib, exo, libXtst, xorgproto, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk3, hicolor-icon-theme, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-cpugraph-plugin";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "193bj1p54l4zrvgdjj0pvjn161d6dn82jh9invcy09sqwlj0mkiy";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    glib
    exo
    libXtst
    xorgproto
    libxfce4util
    libxfce4ui
    xfce4-panel
    xfconf
    gtk3
    hicolor-icon-theme
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-cpugraph-plugin";
    description = "CPU graph show for Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
