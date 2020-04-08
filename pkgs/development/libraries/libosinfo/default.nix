{ stdenv
, fetchurl
, fetchpatch
, pkgconfig
, meson
, ninja
, gettext
, gobject-introspection
, gtk-doc
, docbook_xsl
, glib
, libsoup
, libxml2
, libxslt
, check
, curl
, perl
, hwdata
, osinfo-db
, substituteAll
, vala ? null
}:

stdenv.mkDerivation rec {
  pname = "libosinfo";
  version = "1.7.1";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1s97sv24bybggjx6hgqba2qdqz3ivfpd4cmkh4zm5y59sim109mv";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    vala
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    perl # for pod2man
  ];
  buildInputs = [
    glib
    libsoup
    libxml2
    libxslt
  ];
  checkInputs = [
    check
    curl
    perl
  ];

  patches = [
    (substituteAll {
      src = ./osinfo-db-data-dir.patch;
      osinfo_db_data_dir = "${osinfo-db}/share";
    })
  ];

  mesonFlags = [
    "-Dwith-usb-ids-path=${hwdata}/share/hwdata/usb.ids"
    "-Dwith-pci-ids-path=${hwdata}/share/hwdata/pci.ids"
    "-Denable-gtk-doc=true"
  ];

  # FIXME: fails two new tests added in 1.7.1:
  # libosinfo:symbols / check-symfile
  # 3/24 libosinfo:symbols / check-symsorting
  doCheck = false;

  meta = with stdenv.lib; {
    description = "GObject based library API for managing information about operating systems, hypervisors and the (virtual) hardware devices they can support";
    homepage = https://libosinfo.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
