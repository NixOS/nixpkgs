{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libxml2, libsoup, upower,
  libxfce4ui, libxfce4util, xfce4-panel, hicolor-icon-theme, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-weather-plugin";
  version = "0.10.1";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "12bs2rfmmy021087i10vxibdbbvd5vld0vk3h5hymhpz7rgszcmg";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    gtk3
    libxml2
    libsoup
    upower
    libxfce4ui
    libxfce4util
    xfce4-panel
    hicolor-icon-theme
  ];

  enableParallelBuilding = true;
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-weather-plugin";
    description = "Weather plugin for the Xfce desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
