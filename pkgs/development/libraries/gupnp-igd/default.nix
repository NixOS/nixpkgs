{ lib, stdenv
, fetchurl
, pkg-config
, meson
, ninja
, gettext
, gobject-introspection
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, glib
, gupnp
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gupnp-igd";
  version = "1.2.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-S1EgCYqhPt0ngYup7k1/6WG/VAv1DQVv9wPGFUXgK+E=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  propagatedBuildInputs = [
    glib
    gupnp
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  # Seems to get stuck sometimes.
  # https://github.com/NixOS/nixpkgs/issues/119288
  #doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Library to handle UPnP IGD port mapping";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
