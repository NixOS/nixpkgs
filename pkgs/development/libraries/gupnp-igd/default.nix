{ lib, stdenv
, fetchurl
, fetchpatch
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

  patches = [
    # both patches are unreleased commits for gupnp 1.6.x / libsoup 3.x compat
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gupnp-igd/-/commit/649b7100339c57531a8e31f69220f8e17f0860e0.diff";
      sha256 = "sha256-5YxpClasT5ZUb4uKkN0nHxTColwcsSSKX6zdxjJZmn4=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gupnp-igd/-/commit/79a1e4cf8c256132978a1d8ab718c8ad132386de.diff";
      sha256 = "sha256-1TFq+s5T7Ymq8g7gcbpMSHsBuncbl1JU4waOgk4mq/0=";
    })
  ];

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
