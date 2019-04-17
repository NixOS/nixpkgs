{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, gobject-introspection
, vala
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, docbook_xml_dtd_44
, glib
, gssdp
, libsoup
, libxml2
, libuuid
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gupnp";
  version = "1.2.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0911lv1bivsyv9wwdxm0i1w4r89j0vyyqp200gsfdnzk6v1a4x7x";
  };

  patches = [
    # Nix’s pkg-config ignores Requires.private
    # https://github.com/NixOS/nixpkgs/commit/1e6622f4d5d500d6e701bd81dd4a22977d10637d
    # We are essentialy reverting the following patch for now
    # https://bugzilla.gnome.org/show_bug.cgi?id=685477
    # at least until Requires.internal or something is implemented
    # https://gitlab.freedesktop.org/pkg-config/pkg-config/issues/7
    ./fix-requires.patch

    # fix deadlock in gupnp-igd tests
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gupnp/commit/d208562657f62b34759896ca9e974bd582d1f963.patch;
      sha256 = "02kzsb4glxhgb1npf6qqgafiki0ws75sly5h470431mihc6sgp4f";
    })
    # fix breakage in gupnp-igd tests
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gupnp/commit/0648399acb989473119fe59d0b9f65c923e69483.patch;
      sha256 = "0ba0rngk3a4n3z4dmq06wzgh0n3q9la1nr25qdxqbwlszmxfxpjf";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
    vala
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    docbook_xml_dtd_44
  ];

  buildInputs = [
    libuuid
  ];

  propagatedBuildInputs = [
    glib
    gssdp
    libsoup
    libxml2
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = http://www.gupnp.org/;
    description = "An implementation of the UPnP specification";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
