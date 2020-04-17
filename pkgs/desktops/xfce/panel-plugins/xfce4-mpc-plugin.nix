{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui,
 xfconf, gtk2, exo, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-mpc-plugin";
  version = "0.4.5";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "1kvgq1pq7cykqdc3227dq0izad093ppfw3nfsrcp9i8mi6i5f7z7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel
    xfconf gtk2 exo ];
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "MPD plugin for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ ];
    broken = true;
  };
}
