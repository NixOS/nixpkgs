{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gobject-introspection, gtk-doc, docbook_xsl
, glib, libsoup, libxml2, libxslt, check, curl, perl, hwdata, osinfo-db, vala ? null
}:

stdenv.mkDerivation rec {
  pname = "libosinfo";
  version = "1.5.0";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "12b0xj9fz9q91d1pz9xm6aqap5k1ip0m9m3qvqmwjy1lk1kjasdz";
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
