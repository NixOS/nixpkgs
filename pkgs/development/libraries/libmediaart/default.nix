{ stdenv, fetchurl, meson, ninja, pkgconfig, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_412, glib, gdk-pixbuf, gobject-introspection, gnome3, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libmediaart";
  version = "1.9.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "a57be017257e4815389afe4f58fdacb6a50e74fd185452b23a652ee56b04813d";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gtk-doc docbook_xsl docbook_xml_dtd_412 gobject-introspection ];
  buildInputs = [ glib gdk-pixbuf ];

  patches = [
    # https://bugzilla.gnome.org/show_bug.cgi?id=792272
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libmediaart/commit/a704d0b6cfea091274bd79aca6d15f19b4f6e5b5.patch";
      sha256 = "0606qfmdqxcxrydv1fgwq11hmas34ba4a5kzbbqdhfh0h9ldgwkv";
    })
  ];

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
