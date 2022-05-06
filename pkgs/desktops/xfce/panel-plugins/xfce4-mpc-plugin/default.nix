{ lib, stdenv, fetchurl, pkg-config, intltool, libxfce4util, xfce4-panel,
  libxfce4ui, gtk3, exo, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-mpc-plugin";
  version = "0.5.2";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-7v54t7a5UxKzpSgUt/Yy3JKXDBs+lTXeYWMVdJv2d2A=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    gtk3
    exo
  ];

  passthru.updateScript = xfce.archiveUpdater { inherit category pname version; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mpc-plugin";
    description = "MPD plugin for Xfce panel";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
