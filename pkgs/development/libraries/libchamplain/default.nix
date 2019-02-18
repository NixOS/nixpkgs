{ fetchurl, stdenv, pkgconfig, glib, gtk3, cairo, sqlite, gnome3
, clutter-gtk, libsoup, gobject-introspection /*, libmemphis */ }:

let
  pname = "libchamplain";
  version = "0.12.16";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "13chvc2n074i0jw5jlb8i7cysda4yqx58ca6y3mrlrl9g37k2zja";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gobject-introspection ];

  propagatedBuildInputs = [ glib gtk3 cairo clutter-gtk sqlite libsoup ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/libchamplain;
    license = licenses.lgpl2Plus;

    description = "C library providing a ClutterActor to display maps";

    longDescription = ''
      libchamplain is a C library providing a ClutterActor to display
       maps.  It also provides a Gtk+ widget to display maps in Gtk+
       applications.  Python and Perl bindings are also available.  It
       supports numerous free map sources such as OpenStreetMap,
       OpenCycleMap, OpenAerialMap, and Maps for free.
    '';

     maintainers = gnome3.maintainers;
     platforms = platforms.gnu ++ platforms.linux;  # arbitrary choice
  };
}
