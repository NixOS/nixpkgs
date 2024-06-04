{ lib
, stdenv
, buildPackages
, substituteAll
, fetchurl
, pkg-config
, gettext
, graphene
, gi-docgen
, meson
, mesonEmulatorHook
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
, harfbuzz
, xorg
, libepoxy
, libxkbcommon
, libpng
, libtiff
, libjpeg
, libxml2
, gnome
, gsettings-desktop-schemas
, gst_all_1
, sassc
, trackerSupport ? stdenv.isLinux
, tracker
, x11Support ? stdenv.isLinux
, waylandSupport ? stdenv.isLinux
, libGL
# experimental and can cause crashes in inspector
, vulkanSupport ? stdenv.isLinux
, shaderc
, vulkan-loader
, vulkan-headers
, libdrm
, wayland
, wayland-protocols
, wayland-scanner
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux
, compileSchemas ? stdenv.hostPlatform.emulatorAvailable buildPackages
, cups
, AppKit
, Cocoa
, libexecinfo
, broadwaySupport ? true
, testers
}:

let

  gtkCleanImmodulesCache = substituteAll {
    src = ./hooks/clean-immodules-cache.sh;
    gtk_module_path = "gtk-4.0";
    gtk_binary_version = "4.0.0";
  };

in

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk4";
  version = "4.14.3";

  outputs = [ "out" "dev" ] ++ lib.optionals x11Support [ "devdoc" ];
  outputBin = "dev";

  setupHooks = [
    ./hooks/drop-icon-theme-cache.sh
    gtkCleanImmodulesCache
  ];

  src = fetchurl {
    url = with finalAttrs; "mirror://gnome/sources/gtk/${lib.versions.majorMinor version}/gtk-${version}.tar.xz";
    hash = "sha256-K+XIWL3vEQTTeEjJd5wIk3LI0xUD9u/EuU5TtUb8mkM=";
  };

  depsBuildBuild = [
    pkg-config
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
    gi-docgen
    libxml2 # for xmllint
  ] ++ lib.optionals (compileSchemas && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ] ++ lib.optionals waylandSupport [
    wayland-scanner
  ] ++ lib.optionals vulkanSupport [
    shaderc # for glslc
  ] ++ finalAttrs.setupHooks;

  buildInputs = [
    libxkbcommon
    libpng
    libtiff
    libjpeg
    (libepoxy.override { inherit x11Support; })
    isocodes
  ] ++ lib.optionals vulkanSupport [
    vulkan-headers
    libdrm
  ] ++ [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    fribidi
    harfbuzz
  ] ++ (with xorg; [
    libICE
    libSM
    libXcursor
    libXdamage
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
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    libexecinfo
  ];
  #TODO: colord?

  propagatedBuildInputs = [
    # Required by pkg-config files.
    cairo
    gdk-pixbuf
    glib
    graphene
    pango
  ] ++ lib.optionals waylandSupport [
    wayland
  ] ++ lib.optionals vulkanSupport [
    vulkan-loader
  ] ++ [
    # Required for GSettings schemas at runtime.
    # Will be picked up by wrapGAppsHook4.
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    # ../docs/tools/shooter.c:4:10: fatal error: 'cairo-xlib.h' file not found
    (lib.mesonBool "documentation" x11Support)
    "-Dbuild-tests=false"
    (lib.mesonEnable "tracker" trackerSupport)
    (lib.mesonBool "broadway-backend" broadwaySupport)
    (lib.mesonEnable "vulkan" vulkanSupport)
    (lib.mesonEnable "print-cups" cupsSupport)
    (lib.mesonBool "x11-backend" x11Support)
  ] ++ lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
    "-Dmedia-gstreamer=disabled" # requires gstreamer-gl
  ];

  doCheck = false; # needs X11

  separateDebugInfo = stdenv.isLinux;

  # These are the defines that'd you'd get with --enable-debug=minimum (default).
  # See: https://developer.gnome.org/gtk3/stable/gtk-building.html#extra-configuration-options
  env = {
    NIX_CFLAGS_COMPILE = "-DG_ENABLE_DEBUG -DG_DISABLE_CAST_CHECKS";
  } // lib.optionalAttrs stdenv.hostPlatform.isMusl {
    NIX_LDFLAGS = "-lexecinfo";
  };

  postPatch = ''
    # this conditional gates the installation of share/gsettings-schemas/.../glib-2.0/schemas/gschemas.compiled.
    substituteInPlace meson.build \
      --replace 'if not meson.is_cross_build()' 'if ${lib.boolToString compileSchemas}'

    files=(
      build-aux/meson/gen-profile-conf.py
      build-aux/meson/gen-visibility-macros.py
      demos/gtk-demo/geninclude.py
      gdk/broadway/gen-c-array.py
      gdk/gen-gdk-gresources-xml.py
      gtk/gen-gtk-gresources-xml.py
      gtk/gentypefuncs.py
    )

    chmod +x ''${files[@]}
    patchShebangs ''${files[@]}

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
  '' + lib.optionalString broadwaySupport ''
    # Broadway daemon
    moveToOutput bin/gtk4-broadwayd "$out"
  '';

  # Wrap demos
  postFixup =  lib.optionalString (!stdenv.isDarwin) ''
    demos=(gtk4-demo gtk4-demo-application gtk4-icon-browser gtk4-widget-factory)

    for program in ''${demos[@]}; do
      wrapProgram $dev/bin/$program \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/${finalAttrs.pname}-${finalAttrs.version}"
    done
  '' + lib.optionalString x11Support ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gtk";
      versionPolicy = "odd-unstable";
      attrPath = "gtk4";
    };
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
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
    maintainers = teams.gnome.members ++ (with maintainers; [ raskin ]);
    platforms = platforms.all;
    changelog = "https://gitlab.gnome.org/GNOME/gtk/-/raw/${finalAttrs.version}/NEWS";
    pkgConfigModules = [
      "gtk4"
      "gtk4-broadway"
      "gtk4-unix-print"
      "gtk4-wayland"
      "gtk4-x11"
    ];
  };
})
