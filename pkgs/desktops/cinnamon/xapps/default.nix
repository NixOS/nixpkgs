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
, pkgconfig
, python3
, stdenv
, vala
, wrapGAppsHook
, inxi
, mate
}:

stdenv.mkDerivation rec {
  pname = "xapps";
  version = "1.6.10";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1jkxvqv9fxf9il5qfyddn4j4nkxgbxlil8vizbx99xz0kafb81vp";
  };

  # TODO: https://github.com/NixOS/nixpkgs/issues/36468
  NIX_CFLAGS_COMPILE = [
    "-I${glib.dev}/include/gio-unix-2.0"
  ];

  patches = [
    (fetchpatch { # details see https://github.com/linuxmint/xapps/pull/65
      url = "https://github.com/linuxmint/xapps/compare/d361d9cf357fade59b4bb68df2dcb2c0c39f90e1...2dfe82ec68981ea046345b2be349bd56293579f7.diff";
      sha256 = "0sffclamvjas8ad57kxrg0vrgrd95xsk0xdl53dc3yivpxkfxrnk";
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    (python3.withPackages(ps: with ps; [
      pygobject3
      setproctitle # mate applet
    ]))
    libgnomekbd
    gdk-pixbuf
    xorg.libxkbfile
    python3.pkgs.pygobject3 # for .pc file
    mate.mate-panel # for gobject-introspection
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

    # The fetchpatch hook removes the renames, so postPatch has to rename those files, remove once PR merged
    mv files/usr/bin/pastebin scripts/pastebin
    mv files/usr/bin/upload-system-info scripts/upload-system-info
    mv files/usr/bin/xfce4-set-wallpaper scripts/xfce4-set-wallpaper
    mv files/usr/share/icons/hicolor icons

    patchShebangs \
      libxapp/g-codegen.py \
      schemas/meson_install_schemas.py

    # Patch pastebin & inxi location
    sed "s|/usr/bin/pastebin|$out/bin/pastebin|" -i scripts/upload-system-info
    sed "s|'inxi'|'${inxi}/bin/inxi'|" -i scripts/upload-system-info
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/xapps";
    description = "Cross-desktop libraries and common resources";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
