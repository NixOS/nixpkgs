{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gobject-introspection, gtk-doc, docbook_xsl
, glib, libsoup, libxml2, libxslt, check, curl, perl, hwdata, osinfo-db, vala ? null
}:

stdenv.mkDerivation rec {
  name = "libosinfo-1.2.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${name}.tar.gz";
    sha256 = "0y2skfrcg38y212qqd26vs3sg566j3qnsgvvm23pfi4j7z7ly9gf";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [
    pkgconfig vala intltool gobject-introspection gtk-doc docbook_xsl
  ];
  buildInputs = [ glib libsoup libxml2 libxslt ];
  checkInputs = [ check curl perl ];

  patches = [
    ./osinfo-db-data-dir.patch
    # Fix bug causing tests to fail (and presumably the real scenarios they're representative of)
    # using upstream commits:
    (fetchpatch {
      url = "https://gitlab.com/libosinfo/libosinfo/commit/b9cb227842948b1b2289cdd3e9b8d925664c2ee7.patch";
      sha256 = "0nj0wmibq52j8qbzmxfzj76fpkqjs18kssbb9lmfhz16s30darbw";
    })
    (fetchpatch {
      url = "https://gitlab.com/libosinfo/libosinfo/commit/e6168463f4fc659b9827b5c8694dc1c6d7d5239a.patch";
      sha256 = "135yfhjm2wxip5dnng3r9k9igfhdi1083ys4a4f3ipjxfskcs9rv";
    })
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace osinfo/osinfo_loader.c --subst-var-by OSINFO_DB_DATA_DIR "${osinfo-db}/share"
  '';

  configureFlags = [
    "--with-usb-ids-path=${hwdata}/share/hwdata/usb.ids"
    "--with-pci-ids-path=${hwdata}/share/hwdata/pci.ids"
    "--enable-gtk-doc"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GObject based library API for managing information about operating systems, hypervisors and the (virtual) hardware devices they can support";
    homepage = https://libosinfo.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
