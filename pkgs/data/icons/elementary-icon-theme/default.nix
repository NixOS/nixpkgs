{ stdenv, fetchurl, cmake, gtk3 }:

stdenv.mkDerivation rec {
  name = "elementary-icon-theme-${version}";
  version = "4.3.1";

  src = fetchurl {
    url = "https://launchpad.net/elementaryicons/4.x/${version}/+download/${name}.tar.xz";
    sha256 = "1rp22igvnx71l94j5a6px142329djhk2psm1wfgbhdxbj23hw9kb";
  };

  nativeBuildInputs = [ cmake gtk3 ];

  postPatch = "cat > volumeicon/CMakeLists.txt";
  postFixup = "gtk-update-icon-cache $out/share/icons/elementary";


  meta = with stdenv.lib; {
    description = "Elementary icon theme";
    homepage = https://launchpad.net/elementaryicons;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ simonvandel ];
  };
}
