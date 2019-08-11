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
    # https://nvd.nist.gov/vuln/detail/CVE-2019-13313
    (fetchpatch {
      url = "https://gitlab.com/libosinfo/libosinfo/commit/3654abee6ead9f11f8bb9ba8fc71efd6fa4dabbc.patch";
      name = "CVE-2019-13313-1.patch";
      sha256 = "1lybywfj6b41zfjk33ap90bab5l84lf5y3kif7vd2b6wq5r91rcn";
    })
    (fetchpatch {
      url = "https://gitlab.com/libosinfo/libosinfo/commit/08fb8316b4ac42fe74c1fa5ca0ac593222cdf81a.patch";
      name = "CVE-2019-13313-2.patch";
      sha256 = "1f6rhkrgy3j8nmidk97wnz6p35zs1dsd63d3np76q7qs7ra74w9z";
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
