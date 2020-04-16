{ stdenv, fetchurl, pkgconfig, intltool, gtk2, libxml2, libsoup, upower,
  libxfce4ui, libxfce4util, xfce4-panel, hicolor-icon-theme, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-weather-plugin";
  version = "0.8.10";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "1f7ac2zr5s5w6krdpgsq252wxhhmcblia3j783132ilh8k246vgf";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk2 libxml2 libsoup upower libxfce4ui libxfce4util
   xfce4-panel hicolor-icon-theme ];

  enableParallelBuilding = true;
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "Weather plugin for the Xfce desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
