{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_412
, libxml2
, gst_all_1
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gupnp-dlna";
  version = "0.12.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "PVO5b4W8VijTPjZ+yb8q2zjvKzTXrQQ0proM9K2QSOY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    libxml2
    gst_all_1.gst-plugins-base
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  postPatch = ''
    chmod +x tests/test-discoverer.sh.in
    patchShebangs tests/test-discoverer.sh.in
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GUPnP/";
    description = "Library to ease DLNA-related bits for applications using GUPnP";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
