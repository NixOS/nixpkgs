{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, gtk3, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-systemload-plugin";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0x87a8h5l3ashz1ksfaxcpn9a392jzlsbx5n5pga8g90fp2hf905";
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
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-systemload-plugin";
    description = "System load plugin for Xfce panel";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
