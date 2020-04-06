{ stdenv, fetchurl, meson, ninja, gettext, pkgconfig, glib
, fixDarwinDylibNames, gobject-introspection, gnome3
}:

let
  pname = "atk";
  version = "2.35.1";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "111qajn7kxwmh40drc8i6jc3hnril2rp63n207q92pl47zx614xy";
  };

  outputs = [ "out" "dev" ];

  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobject-introspection glib ];

  propagatedBuildInputs = [
    # Required by atk.pc
    glib
  ];

  patches = [
    # meson builds an incorrect .pc file
    # glib should be Requires not Requires.private
    ./fix_pc.patch
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
