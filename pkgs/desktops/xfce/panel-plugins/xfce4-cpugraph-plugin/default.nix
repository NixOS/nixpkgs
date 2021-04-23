{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, glib
, exo
, libXtst
, xorgproto
, libxfce4util
, xfce4-panel
, libxfce4ui
, xfconf
, gtk3
, hicolor-icon-theme
, xfce
}:

let
  category = "panel-plugins";
in stdenv.mkDerivation rec {
  pname  = "xfce4-cpugraph-plugin";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "13302psv0fzg2dsgadr8j6mb06k1bsa4zw6hxmb644vqlvcwq37v";
  };

  nativeBuildInputs = [
    pkg-config
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

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-cpugraph-plugin";
    description = "CPU graph show for Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
