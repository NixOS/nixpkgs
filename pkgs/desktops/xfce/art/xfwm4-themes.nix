{ stdenv, fetchurl, xfce }:

let
  category = "art";
in

stdenv.mkDerivation rec {
  pname  = "xfwm4-themes";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0xfmdykav4rf6gdxbd6fhmrfrvbdc1yjihz7r7lba0wp1vqda51j";
  };
  
  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with stdenv.lib; {
    homepage = "https://www.xfce.org/";
    description = "Themes for Xfce";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.volth ];
  };
}
