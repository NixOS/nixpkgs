{ stdenv, fetchurl, pkgconfig, intltool, gobjectIntrospection, gtk-doc, docbook_xsl
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
    pkgconfig vala intltool gobjectIntrospection gtk-doc docbook_xsl
  ];
  buildInputs = [ glib libsoup libxml2 libxslt ];
  checkInputs = [ check curl perl ];

  patches = [
    ./osinfo-db-data-dir.patch
    ./0001-tests-Expand-the-arch-s-parser-for-isodetect.patch
    ./0002-db-Force-anchored-patterns-when-matching-regex.patch
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
