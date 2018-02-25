{ stdenv, fetchurl, pkgconfig, intltool, gobjectIntrospection, gtk-doc, docbook_xsl
, glib, libsoup, libxml2, libxslt, check, curl, perl, hwdata, osinfo-db, vala ? null
}:

stdenv.mkDerivation rec {
  name = "libosinfo-1.1.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${name}.tar.gz";
    sha256 = "0diigllgni6m0sc2h8aid6hmyaq9qb54pm5305m0irfsm2j463v0";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [
    pkgconfig vala intltool gobjectIntrospection gtk-doc docbook_xsl
  ] ++ stdenv.lib.optionals doCheck checkInputs;
  checkInputs = [ check curl perl ];
  buildInputs = [ glib libsoup libxml2 libxslt ];

  patches = [
    ./osinfo-db-data-dir.patch
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace osinfo/osinfo_loader.c --subst-var-by OSINFO_DB_DATA_DIR "${osinfo-db}/share"
  '';

  configureFlags = [
    "--with-usb-ids-path=${hwdata}/data/hwdata/usb.ids"
    "--with-pci-ids-path=${hwdata}/data/hwdata/pci.ids"
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
