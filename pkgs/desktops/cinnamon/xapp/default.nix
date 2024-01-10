{ fetchFromGitHub
, glib
, gobject-introspection
, gtk3
, libgnomekbd
, gdk-pixbuf
, cairo
, xorg
, meson
, ninja
, pkg-config
, python3
, lib
, stdenv
, vala
, wrapGAppsHook
, inxi
, mate
, dbus
, libdbusmenu-gtk3
}:

stdenv.mkDerivation rec {
  pname = "xapp";
  version = "2.8.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-JsaH74h36FTIYVKiULmisK/RFGMZ79rhr7sacFnpFas=";
  };

  # Recommended by upstream, which enables the build of xapp-debug.
  # https://github.com/linuxmint/xapp/issues/169#issuecomment-1574962071
  mesonBuildType = "debugoptimized";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    (python3.withPackages (ps: with ps; [
      pygobject3
      setproctitle # mate applet
    ]))
    libgnomekbd
    gdk-pixbuf
    xorg.libxkbfile
    python3.pkgs.pygobject3 # for .pc file
    mate.mate-panel # for gobject-introspection
    dbus
    libdbusmenu-gtk3
  ];

  # Requires in xapp.pc
  propagatedBuildInputs = [
    gtk3
    cairo
    glib
  ];

  mesonFlags = [
    "-Dpy-overrides-dir=${placeholder "out"}/${python3.sitePackages}/gi/overrides"
  ];

  postPatch = ''
    chmod +x schemas/meson_install_schemas.py # patchShebangs requires executable file
    patchShebangs schemas/meson_install_schemas.py

    # Patch pastebin & inxi location
    sed "s|/usr/bin/pastebin|$out/bin/pastebin|" -i scripts/upload-system-info
    sed "s|'inxi'|'${inxi}/bin/inxi'|" -i scripts/upload-system-info
  '';

  # Fix gtk3 module target dir. Proper upstream solution should be using define_variable.
  PKG_CONFIG_GTK__3_0_LIBDIR = "${placeholder "out"}/lib";

  meta = with lib; {
    homepage = "https://github.com/linuxmint/xapp";
    description = "Cross-desktop libraries and common resources";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
