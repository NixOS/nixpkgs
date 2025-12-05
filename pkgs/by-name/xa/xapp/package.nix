{
  fetchFromGitHub,
  glib,
  gobject-introspection,
  gtk3,
  libgnomekbd,
  gdk-pixbuf,
  cairo,
  xorg,
  meson,
  ninja,
  pkg-config,
  python3,
  lib,
  stdenv,
  vala,
  wrapGAppsHook3,
  file,
  inxi,
  mate,
  dbus,
  libdbusmenu-gtk3,
}:

stdenv.mkDerivation rec {
  pname = "xapp";
  version = "3.2.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xapp";
    rev = version;
    hash = "sha256-jO1FyJfAg/kZExAS6gT0u15ans8cDsXfBE5V+w2fQXU=";
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
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    (python3.withPackages (
      ps: with ps; [
        pygobject3
        setproctitle # mate applet
      ]
    ))
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

    # Used in cinnamon-settings
    substituteInPlace scripts/upload-system-info \
      --replace-fail "'/usr/bin/pastebin'" "'$out/bin/pastebin'" \
      --replace-fail "'inxi'" "'${inxi}/bin/inxi'"

    # Used in x-d-p-xapp
    substituteInPlace scripts/xfce4-set-wallpaper \
      --replace-fail "file --mime-type" "${file}/bin/file --mime-type"
  '';

  # Fix gtk3 module target dir. Proper upstream solution should be using define_variable.
  env.PKG_CONFIG_GTK__3_0_LIBDIR = "${placeholder "out"}/lib";

  preFixup = ''
    wrapGApp $out/lib/xapps/xapp-sn-watcher
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/xapp";
    description = "Cross-desktop libraries and common resources";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
