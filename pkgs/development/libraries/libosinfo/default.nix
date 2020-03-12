{ stdenv, fetchurl, fetchpatch, pkgconfig, gettext, gobject-introspection, gtk-doc, docbook_xsl
, glib, libsoup, libxml2, libxslt, check, curl, perl, hwdata, osinfo-db, substituteAll
, vala ? null
}:

stdenv.mkDerivation rec {
  pname = "libosinfo";
  version = "1.6.0";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1iwh35mahch1ls3sgq7wz8kamxrxisrff5ciqzyh2qxlrqf5qf1w";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [
    pkgconfig vala gettext gobject-introspection gtk-doc docbook_xsl
  ];
  buildInputs = [ glib libsoup libxml2 libxslt ];
  checkInputs = [ check curl perl ];

  patches = [
    (substituteAll {
      src = ./osinfo-db-data-dir.patch;
      osinfo_db_data_dir = "${osinfo-db}/share";
    })
  ];

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
