{ stdenv
, lib
, fetchFromGitHub
, gobject-introspection
, pkg-config
, cairo
, glib
, readline
, spidermonkey_102
, meson
, dbus
, ninja
, which
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "cjs";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cjs";
    rev = version;
    hash = "sha256-oSqEAZWEVb8NxFTScl8s5Mb04tCGDyVVslYW00s4YYk=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    which # for locale detection
    libxml2 # for xml-stripblanks
    gobject-introspection
  ];

  buildInputs = [
    cairo
    readline
    spidermonkey_102
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
