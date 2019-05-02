{ fetchurl, stdenv, meson, ninja, pkgconfig, gettext, gtk-doc, docbook_xsl, gobject-introspection, gnome3, libsoup, json-glib, glib }:

stdenv.mkDerivation rec {
  pname = "geocode-glib";
  version = "3.26.1";

  outputs = [ "out" "dev" "devdoc" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "076ydfpyc4n5c9dbqmf26i4pilfi5jpw6cjcgrbgrjbndavnmajv";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext gtk-doc docbook_xsl gobject-introspection ];
  buildInputs = [ glib libsoup json-glib ];

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
