{ stdenv
, lib
, fetchFromGitHub
, gobject-introspection
, pkg-config
, cairo
, glib
, readline
<<<<<<< HEAD
, spidermonkey_102
=======
, spidermonkey_78
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, meson
, dbus
, ninja
, which
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "cjs";
<<<<<<< HEAD
  version = "5.8.0";
=======
  version = "5.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cjs";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-DKCe8dKdYfdeWQ9Iqr0AmDU7YDN9QrQGdTkrBV/ywV0=";
=======
    hash = "sha256-f9esbQi5WWSMAGlEs9HJFToOvmOrbP2lDW1gGh/48gw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    which # for locale detection
    libxml2 # for xml-stripblanks
<<<<<<< HEAD
    gobject-introspection
  ];

  buildInputs = [
    cairo
    readline
    spidermonkey_102
=======
  ];

  buildInputs = [
    gobject-introspection
    cairo
    readline
    spidermonkey_78
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dbus # for dbus-run-session
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dprofiler=disabled"
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cjs";
    description = "JavaScript bindings for Cinnamon";

    longDescription = ''
      This module contains JavaScript bindings based on gobject-introspection.
    '';

    license = with licenses; [
      gpl2Plus
      lgpl2Plus
      mit
      mpl11
    ];

    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
