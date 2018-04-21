{ fetchurl, stdenv, meson, ninja, pkgconfig, gettext, gtk-doc, docbook_xsl, gobjectIntrospection, gnome3, libsoup, json-glib }:

stdenv.mkDerivation rec {
  name = "geocode-glib-${version}";
  version = "3.25.4.1";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0y6p5l2jrr78p7l4hijjhclzbap005y6h06g3aiglg9i5hk6j0gi";
  };

  nativeBuildInputs = with gnome3; [ meson ninja pkgconfig gettext gtk-doc docbook_xsl gobjectIntrospection ];
  buildInputs = with gnome3; [ glib libsoup json-glib ];

  patches = [
    ./installed-tests-path.patch
  ];

  postPatch = ''
    substituteInPlace geocode-glib/tests/meson.build --subst-var-by "installedTests" "$installedTests"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "geocode-glib";
      attrPath = "gnome3.geocode-glib";
    };
  };

  meta = with stdenv.lib; {
    description = "A convenience library for the geocoding and reverse geocoding using Nominatim service";
    license = licenses.lgpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
