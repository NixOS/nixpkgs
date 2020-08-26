{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui,
  gtk2, exo, gnutls, libgcrypt, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-mailwatch-plugin";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "1bfw3smwivr9mzdyq768biqrl4aq94zqi3xjzq6kqnd8561cqjk2";
  };

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    gtk2
    exo # needs exo with gtk2 support
    gnutls
    libgcrypt
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mailwatch-plugin";
    description = "Mail watcher plugin for Xfce panel";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
