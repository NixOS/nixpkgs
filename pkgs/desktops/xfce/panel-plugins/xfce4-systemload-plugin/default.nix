{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, libxfce4util
, xfce4-panel
, libxfce4ui
, gtk3
, xfce
}:

let
  category = "panel-plugins";
in stdenv.mkDerivation rec {
  pname  = "xfce4-systemload-plugin";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "BTG435I8ujvo0GTLi2OLlU33SRXlpEciiZlReEd4mDU=";
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
  ];

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-systemload-plugin";
    description = "System load plugin for Xfce panel";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
