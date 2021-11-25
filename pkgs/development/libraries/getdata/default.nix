{ lib, stdenv, fetchurl, fetchpatch, libtool }:
stdenv.mkDerivation rec {
  pname = "getdata";
  version = "0.10.0";
  src = fetchurl {
    url = "mirror://sourceforge/getdata/${pname}-${version}.tar.xz";
    sha256 = "18xbb32vygav9x6yz0gdklif4chjskmkgp06rwnjdf9myhia0iym";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/libg/libgetdata/0.10.0-10/debian/patches/CVE-2021-20204.patch";
      sha256 = "1lvp1c2pkk9kxniwlvax6d8fsmjrkpxawf71c7j4rfjm6dgvivzm";
    })
  ];

  buildInputs = [ libtool ];

  meta = with lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = "http://getdata.sourceforge.net/";
  };
}
