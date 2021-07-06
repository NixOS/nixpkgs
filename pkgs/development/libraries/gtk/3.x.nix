{ lib
, stdenv
, substituteAll
, fetchurl
, fetchpatch
, pkg-config
, gettext
, docbook-xsl-nons
, docbook_xml_dtd_43
, gtk-doc
, meson
, ninja
, python3
, makeWrapper
, shared-mime-info
, isocodes
, expat
, glib
, cairo
, pango
, gdk-pixbuf
, atk
, at-spi2-atk
, gobject-introspection
, fribidi
, xorg
, epoxy
, json-glib
, libxkbcommon
, libxml2
, gmp
, gnome
, gsettings-desktop-schemas
, sassc
, trackerSupport ? stdenv.isLinux
, tracker
, x11Support ? stdenv.isLinux
, waylandSupport ? stdenv.isLinux
, libGL
, wayland
, wayland-protocols
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux
, withGtkDoc ? stdenv.isLinux
, cups
, AppKit
, Cocoa
, broadwaySupport ? true
}:

let

  gtkCleanImmodulesCache = substituteAll {
    src = ./hooks/clean-immodules-cache.sh;
    gtk_module_path = "gtk-3.0";
    gtk_binary_version = "3.0.0";
  };

in

stdenv.mkDerivation rec {
  pname = "gtk+3";
  version = "3.24.27";

  outputs = [ "out" "dev" ] ++ lib.optional withGtkDoc "devdoc";
  outputBin = "dev";

  setupHooks = [
    ./hooks/drop-icon-theme-cache.sh
    gtkCleanImmodulesCache
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${lib.versions.majorMinor version}/gtk+-${version}.tar.xz";
    sha256 = "09ksflq5j257bf5zn8q2nnf2flicg9qqgfy7za79z7rkf1shc77p";
  };

  patches = [
    ./patches/3.0-immodules.cache.patch

    (fetchpatch {
      name = "Xft-setting-fallback-compute-DPI-properly.patch";
      url = "https://bug757142.bugzilla-attachments.gnome.org/attachment.cgi?id=344123";
      sha256 = "0g6fhqcv8spfy3mfmxpyji93k8d4p4q4fz1v9a1c1cgcwkz41d7p";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    # X11 module requires <gio/gdesktopappinfo.h> which is not installed on Darwin
    # let’s drop that dependency in similar way to how other parts of the library do it
    # e.g. https://gitlab.gnome.org/GNOME/gtk/blob/3.24.4/gtk/gtk-launch.c#L31-33
    # https://gitlab.gnome.org/GNOME/gtk/merge_requests/536
    ./patches/3.0-darwin-x11.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    makeWrapper
    meson
    ninja
    pkg-config
    python3
    sassc
  ] ++ setupHooks ++ lib.optionals withGtkDoc [
    docbook_xml_dtd_43
    docbook-xsl-nons
    gtk-doc
    # For xmllint
    libxml2
  ];

  buildInputs = [
    libxkbcommon
    epoxy
    json-glib
    isocodes
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
  ] ++ lib.optionals trackerSupport [
    tracker
  ];
  #TODO: colord?

  propagatedBuildInputs = with xorg; [
    at-spi2-atk
    atk
    cairo
    expat
    fribidi
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    libICE
    libSM
    libXcomposite
    libXcursor
    libXi
    libXrandr
    libXrender
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    # explicitly propagated, always needed
    Cocoa
  ] ++ lib.optionals waylandSupport [
    libGL
    wayland
    wayland-protocols
  ] ++ lib.optionals xineramaSupport [
    libXinerama
  ] ++ lib.optionals cupsSupport [
    cups
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString withGtkDoc}"
    "-Dtests=false"
    "-Dtracker3=${lib.boolToString trackerSupport}"
    "-Dbroadway_backend=${lib.boolToString broadwaySupport}"
  ];

  doCheck = false; # needs X11

  separateDebugInfo = stdenv.isLinux;

  # These are the defines that'd you'd get with --enable-debug=minimum (default).
  # See: https://developer.gnome.org/gtk3/stable/gtk-building.html#extra-configuration-options
  NIX_CFLAGS_COMPILE = "-DG_ENABLE_DEBUG -DG_DISABLE_CAST_CHECKS";

  postPatch = ''
    files=(
      build-aux/meson/post-install.py
      demos/gtk-demo/geninclude.py
      gdk/broadway/gen-c-array.py
      gdk/gen-gdk-gresources-xml.py
      gtk/cursor/dnd-copy.png
      gtk/gen-gtk-gresources-xml.py
      gtk/gen-rc.py
      gtk/gentypefuncs.py
    )

    chmod +x ''${files[@]}
    patchShebangs ''${files[@]}
  '';

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    # The updater is needed for nixos env and it's tiny.
    moveToOutput bin/gtk-update-icon-cache "$out"
    # Launcher
    moveToOutput bin/gtk-launch "$out"
    # Broadway daemon
    moveToOutput bin/broadwayd "$out"

    # TODO: patch glib directly
    for f in $dev/bin/gtk-encode-symbolic-svg; do
      wrapProgram $f --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    done
  '';

  # Wrap demos
  postFixup =  lib.optionalString (!stdenv.isDarwin) ''
    demos=(gtk3-demo gtk3-demo-application gtk3-icon-browser gtk3-widget-factory)

    for program in ''${demos[@]}; do
      wrapProgram $dev/bin/$program \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/${pname}-${version}"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gtk+";
      attrPath = "gtk3";
    };
  };

  meta = with lib; {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    longDescription = ''
      GTK is a highly usable, feature rich toolkit for creating
      graphical user interfaces which boasts cross platform
      compatibility and an easy to use API.  GTK it is written in C,
      but has bindings to many other popular programming languages
      such as C++, Python and C# among others.  GTK is licensed
      under the GNU LGPL 2.1 allowing development of both free and
      proprietary software with GTK without any license fees or
      royalties.
    '';
    homepage = "https://www.gtk.org/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin ] ++ teams.gnome.members;
    platforms = platforms.all;
    changelog = "https://gitlab.gnome.org/GNOME/gtk/-/raw/${version}/NEWS";
  };
}
