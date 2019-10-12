{
  stdenv, fetchurl, fetchpatch,
  automoc4, cmake_2_8, libxslt, perl, pkgconfig, shared-mime-info,
  attica, docbook_xml_dtd_42, docbook_xsl, giflib,
  libdbusmenu_qt, libjpeg, phonon, qt4, openssl
}:

stdenv.mkDerivation rec {
  version = "4.14.38";
  pname = "kdelibs";
  src = fetchurl {
    url = "mirror://kde/stable/applications/17.08.3/src/${pname}-${version}.tar.xz";
    sha256 = "1zn3yb09sd22bm54is0rn98amj0398zybl550dp406419sil7z9p";
  };
  patches = [
    # https://phabricator.kde.org/D22989
    (fetchpatch {
      url = "https://cgit.kde.org/kdelibs.git/patch/?id=2c3762feddf7e66cf6b64d9058f625a715694a00";
      sha256 = "1wbzywh8lcc66n6y3pxs18h7cwkq6g216faz27san33jpl8ra1i9";
      name = "CVE-2019-14744.patch";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    automoc4 cmake_2_8 libxslt perl pkgconfig shared-mime-info
  ];
  buildInputs = [
    attica giflib libdbusmenu_qt libjpeg openssl
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
    hydraPlatforms = platforms.none;
    homepage = http://www.kde.org;
    license = with licenses; [ gpl2 fdl12 lgpl21 ];
    maintainers = with maintainers; [ gnidorah ];
  };
}
