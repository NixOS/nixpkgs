{
  stdenv, fetchurl,
  automoc4, cmake_2_8, libxslt, perl, pkgconfig, shared-mime-info,
  attica, docbook_xml_dtd_42, docbook_xsl, giflib,
  libdbusmenu_qt, libjpeg, phonon, qt4
}:

stdenv.mkDerivation rec {
  version = "4.14.38";
  name = "kdelibs-${version}";
  src = fetchurl {
    url = "mirror://kde/stable/applications/17.08.3/src/${name}.tar.xz";
    sha256 = "1zn3yb09sd22bm54is0rn98amj0398zybl550dp406419sil7z9p";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    automoc4 cmake_2_8 libxslt perl pkgconfig shared-mime-info
  ];
  buildInputs = [
    attica giflib libdbusmenu_qt libjpeg
  ];
  propagatedBuildInputs = [ qt4 phonon ];

  cmakeFlags = [
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
    "-DKJS_FORCE_DISABLE_PCRE=true"
    "-DWITH_SOLID_UDISKS2=OFF"
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = http://www.kde.org;
    license = with licenses; [ gpl2 fdl12 lgpl21 ];
  };
}
