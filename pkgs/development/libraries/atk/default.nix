{ lib, stdenv, fetchurl, meson, ninja, gettext, pkg-config, glib
, fixDarwinDylibNames, gobject-introspection, gnome
}:

let
  pname = "atk";
  version = "2.36.0";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1217cmmykjgkkim0zr1lv5j13733m4w5vipmy4ivw0ll6rz28xpv";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkg-config gettext gobject-introspection glib ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  propagatedBuildInputs = [
    # Required by atk.pc
    glib
  ];

  patches = [
    # meson builds an incorrect .pc file
    # glib should be Requires not Requires.private
    ./fix_pc.patch
  ];

  mesonFlags = [
    "-Dintrospection=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
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

    homepage = "http://library.gnome.org/devel/atk/";

    license = lib.licenses.lgpl2Plus;

    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };

}
