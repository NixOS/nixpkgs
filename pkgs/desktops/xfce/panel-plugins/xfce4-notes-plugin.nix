{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2, libunique, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-notes-plugin";
  version = "1.7.7";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "05sjbwgch1j93m3r23ksbjnpfk11sf7xjmbb9pm5vl3snc2s3fm7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf gtk2 libunique ];
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "Sticky notes plugin for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
    broken = true;
  };
}
