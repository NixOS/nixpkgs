{ stdenv
, lib
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, glib
, fixDarwinDylibNames
, gobject-introspection
, gnome
}:

stdenv.mkDerivation rec {
  pname = "atk";
  version = "2.38.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "rE3ipO9L1WZQUpUv4WllfmXolcUFff+zwqgQ9hkaDDY=";
  };

  patches = [
    # meson builds an incorrect .pc file
    # glib should be Requires not Requires.private
    ./fix_pc.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gobject-introspection
    glib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [
    # Required by atk.pc
    glib
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

    homepage = "https://gitlab.gnome.org/GNOME/atk";

    license = lib.licenses.lgpl2Plus;

    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };

}
