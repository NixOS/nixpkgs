{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel,
  libxfce4ui, gtk3, exo, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-mpc-plugin";
  version = "0.5.2";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0q3pysdp85b3c7g3b59y3c69g4nw6bvbf518lnri4lxrnsvpizpf";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    gtk3
    exo
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mpc-plugin";
    description = "MPD plugin for Xfce panel";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
