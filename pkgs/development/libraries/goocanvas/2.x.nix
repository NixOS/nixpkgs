{ lib, stdenv, fetchurl, pkg-config, gettext, gtk-doc, gobject-introspection, python3, gtk3, cairo, glib, gnome }:

stdenv.mkDerivation rec {
  pname = "goocanvas";
  version = "2.0.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/goocanvas/2.0/${pname}-${version}.tar.xz";
    sha256 = "141fm7mbqib0011zmkv3g8vxcjwa7hypmq71ahdyhnj2sjvy4a67";
  };

  nativeBuildInputs = [ pkg-config gettext gtk-doc python3 gobject-introspection ];
  buildInputs = [ gtk3 cairo glib ];

  configureFlags = [
    "--disable-python"
  ];
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "$(dev)/share/gir-1.0";
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "$(out)/lib/girepository-1.0";

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "${pname}${lib.versions.major version}";
      packageName = pname;
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "Canvas widget for GTK based on the the Cairo 2D library";
    homepage = "https://gitlab.gnome.org/Archive/goocanvas";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
