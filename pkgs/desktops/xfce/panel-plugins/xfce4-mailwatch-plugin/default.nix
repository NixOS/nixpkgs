{ lib, stdenv, fetchurl, pkg-config, intltool, xfce4-panel, libxfce4ui,
  exo, gnutls, libgcrypt, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-mailwatch-plugin";
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0bmykjhd3gs1737fl3zn5gg6f3vlncak2xqz89zv5018znz1xy90";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    libxfce4ui
    xfce4-panel
    exo
    gnutls
    libgcrypt
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mailwatch-plugin";
    description = "Mail watcher plugin for Xfce panel";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
