{ lib
, stdenv
, substituteAll
, fetchurl
, pkg-config
, gettext
, graphene
, docbook-xsl-nons
, docbook_xml_dtd_43
, gtk-doc
, meson
, ninja
, python3
, makeWrapper
, shared-mime-info
, isocodes
, glib
, cairo
, pango
, pandoc
, gdk-pixbuf
, gobject-introspection
, fribidi
, xorg
, epoxy
, json-glib
, libxkbcommon
, libxml2
, librest
, libsoup
, ffmpeg
, gmp
, gnome3
, gsettings-desktop-schemas
, gst_all_1
, sassc
, trackerSupport ? stdenv.isLinux
, tracker
, x11Support ? stdenv.isLinux
, waylandSupport ? stdenv.isLinux
, libGL
, vulkan-loader
, vulkan-headers
, wayland
, wayland-protocols
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux
, withGtkDoc ? stdenv.isLinux
, cups ? null
, AppKit
, Cocoa
, broadwaySupport ? true
}:

assert cupsSupport -> cups != null;

let

  gtkCleanImmodulesCache = substituteAll {
    src = ./hooks/clean-immodules-cache.sh;
    gtk_module_path = "gtk-4.0";
    gtk_binary_version = "4.0.0";
  };

in

stdenv.mkDerivation rec {
  pname = "gtk4";
  version = "4.0.3";

  outputs = [ "out" "dev" ] ++ lib.optional withGtkDoc "devdoc";
  outputBin = "dev";

  setupHooks = [
    ./hooks/drop-icon-theme-cache.sh
    gtkCleanImmodulesCache
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtk/${lib.versions.majorMinor version}/gtk-${version}.tar.xz";
    sha256 = "18mJNyV5C1C9mjuyeIVtnVQ7RLa5uVHXtg573swTGJA=";
  };

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
    pandoc
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
    vulkan-headers
    librest
    libsoup
    ffmpeg
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    fribidi
  ] ++ (with xorg; [
    libICE
    libSM
    libXcomposite
    libXcursor
    libXi
    libXrandr
    libXrender
  ]) ++ lib.optionals stdenv.isDarwin [
    AppKit
  ] ++ lib.optionals trackerSupport [
    tracker
  ] ++ lib.optionals waylandSupport [
    libGL
    wayland
    wayland-protocols
  ] ++ lib.optionals xineramaSupport [
    xorg.libXinerama
  ] ++ lib.optionals cupsSupport [
    cups
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];
  #TODO: colord?

  propagatedBuildInputs = [
    # Required by pkg-config files.
    cairo
    gdk-pixbuf
    glib
    graphene
    pango
    vulkan-loader # TODO: Possibly not used on Darwin

    # Required for GSettings schemas at runtime.
    # Will be picked up by wrapGAppsHook.
    gsettings-desktop-schemas
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
      gtk/gen-gtk-gresources-xml.py
      gtk/gentypefuncs.py
      docs/reference/gtk/gtk-markdown-to-docbook
    )

    chmod +x ''${files[@]}
    patchShebangs ''${files[@]}
  '';

  postBuild =  lib.optionalString withGtkDoc ''
    # Meson not building `custom_target`s passed to `custom_files` argument of `gnome.gtkdoc` function
    # as part of the `install` target. We have to build the docs manually first.
    # https://github.com/mesonbuild/meson/issues/2831
    ninja g{t,d,s}k4-doc
  '';

  preInstall = ''
    OLD_PATH="$PATH"
    PATH="$PATH:$dev/bin" # so the install script finds gtk4-update-icon-cache
  '';

  postInstall = ''
    PATH="$OLD_PATH"
  '' + lib.optionalString (!stdenv.isDarwin) ''
    # The updater is needed for nixos env and it's tiny.
    moveToOutput bin/gtk4-update-icon-cache "$out"
    # Launcher
    moveToOutput bin/gtk-launch "$out"

    # TODO: patch glib directly
    for f in $dev/bin/gtk4-encode-symbolic-svg; do
      wrapProgram $f --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    done
  '';

  # Wrap demos
  postFixup =  lib.optionalString (!stdenv.isDarwin) ''
    demos=(gtk4-demo gtk4-demo-application gtk4-icon-browser gtk4-widget-factory)

    for program in ''${demos[@]}; do
      wrapProgram $dev/bin/$program \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/${pname}-${version}"
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtk";
      attrPath = "gtk4";
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
    maintainers = with maintainers; [ raskin lethalman worldofpeace ];
    platforms = platforms.all;
    changelog = "https://gitlab.gnome.org/GNOME/gtk/-/raw/${version}/NEWS";
  };
}
