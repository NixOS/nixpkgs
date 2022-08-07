{ fetchFromGitHub
, fetchpatch
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
  version = "2.2.14";

  outputs = [ "out" "dev" ];

  patches = [
    # Add missing gio-unix-2.0 dependency, can be removed on next update
    # https://github.com/linuxmint/xapp/pull/156
    (fetchpatch {
      url = "https://github.com/linuxmint/xapp/commit/052081f75d1c1212aeb6a913772723c81607bcb3.patch";
      sha256 = "sha256-VL70Y1FIa7lQ/zKjEx0GhaU1QRu4z6Yu400/bDbgZgM=";
    })
  ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-BebsS7y/hRQSc4rYOIWJ+sSJ5fLZaCpNAE48JnviUUc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
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

    patchShebangs \
      libxapp/g-codegen.py \
      meson-scripts/g-codegen.py \
      schemas/meson_install_schemas.py

    # Patch pastebin & inxi location
    sed "s|/usr/bin/pastebin|$out/bin/pastebin|" -i scripts/upload-system-info
    sed "s|'inxi'|'${inxi}/bin/inxi'|" -i scripts/upload-system-info

    # Patch gtk3 module target dir
    substituteInPlace libxapp/meson.build \
         --replace "gtk3_dep.get_pkgconfig_variable('libdir')" "'$out'"
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/xapp";
    description = "Cross-desktop libraries and common resources";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
