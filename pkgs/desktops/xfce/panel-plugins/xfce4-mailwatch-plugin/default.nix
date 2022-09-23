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
    sha256 = "sha256-IPkevv0ogLJ/Qh93MRWzdA9n3iv2D+rOOEG/0aCcvi4=";
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

  passthru.updateScript = xfce.archiveUpdater { inherit category pname version; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mailwatch-plugin";
    description = "Mail watcher plugin for Xfce panel";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
