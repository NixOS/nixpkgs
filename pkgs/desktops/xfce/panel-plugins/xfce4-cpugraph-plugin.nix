{ stdenv, fetchurl, pkgconfig, intltool, glib, exo, libXtst, xorgproto, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2, hicolor-icon-theme, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-cpugraph-plugin";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "1izl53q95m5xm2fiq7385vb1i9nwgjizxkmgpgh33zdckb40xnl5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib exo libXtst xorgproto libxfce4util libxfce4ui xfce4-panel xfconf gtk2 hicolor-icon-theme ];
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "CPU graph show for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
