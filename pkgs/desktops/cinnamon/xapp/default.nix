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
<<<<<<< HEAD
  version = "2.6.1";
=======
  version = "2.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ZxIPiDLcMHEmlnrImctI2ZfH3AIOjB4m/RPGipJ7koM=";
  };

  # Recommended by upstream, which enables the build of xapp-debug.
  # https://github.com/linuxmint/xapp/issues/169#issuecomment-1574962071
  mesonBuildType = "debugoptimized";

=======
    hash = "sha256-j04vy/uVWY08Xdxqfo2MMUAlqsUMJTsAt67+XjkdhFg=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
<<<<<<< HEAD
    gobject-introspection
  ];

  buildInputs = [
=======
  ];

  buildInputs = [
    gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    patchShebangs schemas/meson_install_schemas.py
=======

    patchShebangs \
      libxapp/g-codegen.py \
      meson-scripts/g-codegen.py \
      schemas/meson_install_schemas.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    # Patch pastebin & inxi location
    sed "s|/usr/bin/pastebin|$out/bin/pastebin|" -i scripts/upload-system-info
    sed "s|'inxi'|'${inxi}/bin/inxi'|" -i scripts/upload-system-info
<<<<<<< HEAD
  '';

  # Fix gtk3 module target dir. Proper upstream solution should be using define_variable.
  PKG_CONFIG_GTK__3_0_LIBDIR = "${placeholder "out"}/lib";
=======

    # Patch gtk3 module target dir
    substituteInPlace libxapp/meson.build \
         --replace "gtk3_dep.get_pkgconfig_variable('libdir')" "'$out'"
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/linuxmint/xapp";
    description = "Cross-desktop libraries and common resources";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
