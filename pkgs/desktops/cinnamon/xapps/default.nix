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
, lib, stdenv
, vala
, wrapGAppsHook
, inxi
, mate
, dbus
, libdbusmenu-gtk3
}:

stdenv.mkDerivation rec {
  pname = "xapps";
  version = "1.8.9";

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      url = "https://github.com/linuxmint/xapp/pull/110/commits/208563d4e2bbcfbeb4425d05f649867065c37615.patch";
      sha256 = "0brqndfgawhayrm36cjh6fkff274729jivjq3h5jx93lprvl2zih";
    })
  ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "01jx7612p0c0pi0r7fn5g08s6zjfmq1gfm5hi0fkzl0fxf2cx7a7";
  };

  # TODO: https://github.com/NixOS/nixpkgs/issues/36468
  NIX_CFLAGS_COMPILE = [
    "-I${glib.dev}/include/gio-unix-2.0"
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
    (python3.withPackages(ps: with ps; [
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
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/xapps";
    description = "Cross-desktop libraries and common resources";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
