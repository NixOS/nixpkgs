{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, xfce4-panel
, libxfce4ui
, xfconf
, xfce
}:

let
  category = "panel-plugins";
in stdenv.mkDerivation rec {
  pname  = "xfce4-systemload-plugin";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0lknh5l30qs5c69wwjcblbyhczvdbxs59fqkb8mpqbfm05w01lan";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libxfce4ui
    xfce4-panel
    xfconf
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
