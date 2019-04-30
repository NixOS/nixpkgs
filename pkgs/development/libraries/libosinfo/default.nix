{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gobject-introspection, gtk-doc, docbook_xsl
, glib, libsoup, libxml2, libxslt, check, curl, perl, hwdata, osinfo-db, vala ? null
}:

stdenv.mkDerivation rec {
  name = "libosinfo-1.4.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${name}.tar.gz";
    sha256 = "0ra1p2rnnwkq0181ayn0l0rs1pvk4a0i8fa08nqjfmqs5fl637m2";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [
    pkgconfig vala intltool gobject-introspection gtk-doc docbook_xsl
  ];
  buildInputs = [ glib libsoup libxml2 libxslt ];
  checkInputs = [ check curl perl ];

  patches = [
    ./osinfo-db-data-dir.patch
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
