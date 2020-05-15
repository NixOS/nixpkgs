{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk3, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-eyes-plugin";
  version = "4.5.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "17gj6fbvvrdzvz61czmia8hqynllsnmhk61fs4aml443cc1h1bpx";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];
  
  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    xfconf
    gtk3
  ];
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-eyes-plugin";
    description = "Rolling eyes (following mouse pointer) plugin for the Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
