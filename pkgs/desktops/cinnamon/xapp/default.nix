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
  version = "2.4.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-etB+q7FIwbApTUk8RohAy3kHX8Vb4cSY/qkvhj94yTM=";
  };

  patches = [
    # xapp-sn-watcher crashes on cinnamon with glib 2.76.0
    # https://github.com/linuxmint/xapp/issues/165
    (fetchpatch {
      url = "https://github.com/linuxmint/xapp/commit/3ef9861d6228c2061fbde2c0554be5ae6f42befa.patch";
      sha256 = "sha256-7hYXA43UQpBLLjRVPoACc8xdhKyKnt3cDUBL4PhEtJY=";
    })
  ];

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
