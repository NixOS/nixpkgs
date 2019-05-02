{ stdenv, fetchurl, meson, ninja, gettext, pkgconfig, glib
, fixDarwinDylibNames, gobject-introspection, gnome3
}:

let
  pname = "atk";
  version = "2.32.0";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1k4i817bd2w5b9z394f2yyx95591l2746wa40am0vvz4gzdgwhfb";
  };

  outputs = [ "out" "dev" ];

  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobject-introspection ];

  propagatedBuildInputs = [
    # Required by atk.pc
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "Accessibility toolkit";

    longDescription = ''
      ATK is the Accessibility Toolkit.  It provides a set of generic
      interfaces allowing accessibility technologies such as screen
      readers to interact with a graphical user interface.  Using the
      ATK interfaces, accessibility tools have full access to view and
      control running applications.
    '';

    homepage = http://library.gnome.org/devel/atk/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };

}
