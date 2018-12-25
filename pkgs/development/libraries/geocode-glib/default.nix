{ fetchurl, stdenv, meson, ninja, pkgconfig, gettext, gtk-doc, docbook_xsl, gobject-introspection, gnome3, libsoup, json-glib }:

stdenv.mkDerivation rec {
  pname = "geocode-glib";
  version = "3.26.0";

  outputs = [ "out" "dev" "devdoc" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1vmydxs5xizcmaxpkfrq75xpj6pqrpdjizxyb30m00h54yqqch7a";
  };

  nativeBuildInputs = with gnome3; [ meson ninja pkgconfig gettext gtk-doc docbook_xsl gobject-introspection ];
  buildInputs = with gnome3; [ glib libsoup json-glib ];

  patches = [
    ./installed-tests-path.patch
  ];

  postPatch = ''
    substituteInPlace geocode-glib/tests/meson.build --subst-var-by "installedTests" "$installedTests"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A convenience library for the geocoding and reverse geocoding using Nominatim service";
    license = licenses.lgpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
