{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel
, libxfce4ui, xfconf, gtk2, hicolor-icon-theme, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-timer-plugin";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0z46gyw3ihcd1jf0m5z1dsc790xv1cpi8mk1dagj3i4v14gx5mrr";
  };

  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf
    gtk2 hicolor-icon-theme ];

  nativeBuildInputs = [ pkgconfig ];

  hardeningDisable = [ "format" ];
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "A simple XFCE panel plugin that lets the user run an alarm at a specified time or at the end of a specified countdown period";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ ];
    broken = true;
  };
}
