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
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gupnp-igd";
  version = "1.2.0";

  outputs = [ "out" "dev" ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-S1EgCYqhPt0ngYup7k1/6WG/VAv1DQVv9wPGFUXgK+E=";
  };

  depsBuildBuild = [
    pkg-config
  ];

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
    "-Dgtk_doc=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
    "-Dintrospection=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
  ];

  # Seems to get stuck sometimes.
  # https://github.com/NixOS/nixpkgs/issues/119288
  #doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Library to handle UPnP IGD port mapping";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
