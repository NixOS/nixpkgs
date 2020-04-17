{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-eyes-plugin";
  version = "4.4.4";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "1jh02hylvsvfpxrx0bq6fzgy6vnxf9qakgpbfvr63lfkd1dyh314";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf gtk2 ];
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "Eyes following you!";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
    broken = true;
  };
}
