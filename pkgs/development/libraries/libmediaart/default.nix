{ stdenv, fetchurl, meson, ninja, pkgconfig, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_412, glib, gdk_pixbuf, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libmediaart";
  version = "1.9.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "a57be017257e4815389afe4f58fdacb6a50e74fd185452b23a652ee56b04813d";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gtk-doc docbook_xsl docbook_xml_dtd_412 gobject-introspection ];
  buildInputs = [ glib gdk_pixbuf ];

  # FIXME: Turn on again when https://github.com/NixOS/nixpkgs/issues/53701
  # is fixed on master.
  doCheck = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "Library tasked with managing, extracting and handling media art caches";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
