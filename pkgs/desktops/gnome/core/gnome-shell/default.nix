{ fetchurl
, fetchpatch
, substituteAll
, lib, stdenv
, meson
, ninja
, pkg-config
, gnome
, json-glib
, gettext
, libsecret
, python3
, polkit
, networkmanager
, gi-docgen
, at-spi2-core
, libstartup_notification
, unzip
, shared-mime-info
, libgweather
, libjxl
, librsvg
, webp-pixbuf-loader
, geoclue2
, perl
, desktop-file-utils
, libpulseaudio
, libical
, gobject-introspection
, wrapGAppsHook4
, libxslt
, gcr_4
, accountsservice
, gdk-pixbuf
, gdm
, upower
, ibus
, libnma-gtk4
, gnome-desktop
, gsettings-desktop-schemas
, gnome-keyring
, glib
, gjs
, mutter
, evolution-data-server-gtk4
, gtk3
, gtk4
, libadwaita
, sassc
, systemd
, pipewire
, gst_all_1
, adwaita-icon-theme
, gnome-bluetooth
, gnome-clocks
, gnome-settings-daemon
, gnome-autoar
, gnome-tecla
, asciidoc
, bash-completion
, mesa
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pygobject3 ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell";
  version = "46.2";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/${lib.versions.major finalAttrs.version}/gnome-shell-${finalAttrs.version}.tar.xz";
    hash = "sha256-a1hxAcBL+zZKsJzTi12T6+60JUdUyAfPcS+8juP94jg=";
  };

  patches = [
    # Hardcode paths to various dependencies so that they can be found at runtime.
    (substituteAll {
      src = ./fix-paths.patch;
      glib_compile_schemas = "${glib.dev}/bin/glib-compile-schemas";
      gsettings = "${glib.bin}/bin/gsettings";
      tecla = "${lib.getBin gnome-tecla}/bin/tecla";
      unzip = "${lib.getBin unzip}/bin/unzip";
    })

    # Use absolute path for libshew installation to make our patched gobject-introspection
    # aware of the location to hardcode in the generated GIR file.
    ./shew-gir-path.patch

    # Make D-Bus services wrappable.
    ./wrap-services.patch

    # Fix greeter logo being too big.
    # https://gitlab.gnome.org/GNOME/gnome-shell/issues/2591
    # Reverts https://gitlab.gnome.org/GNOME/gnome-shell/-/merge_requests/1101
    ./greeter-logo-size.patch

    # Work around failing fingerprint auth
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gnome-shell/raw/dcd112d9708954187e7490564c2229d82ba5326f/f/0001-gdm-Work-around-failing-fingerprint-auth.patch";
      hash = "sha256-mgXty5HhiwUO1UV3/eDgWtauQKM0cRFQ0U7uocST25s=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gi-docgen
    perl
    wrapGAppsHook4
    sassc
    desktop-file-utils
    libxslt.bin
    asciidoc
    gobject-introspection
  ];

  buildInputs = [
    systemd
    gsettings-desktop-schemas
    gnome-keyring
    glib
    gcr_4
    accountsservice
    libsecret
    polkit
    gdk-pixbuf
    librsvg
    networkmanager
    libstartup_notification
    gjs
    mutter
    libpulseaudio
    evolution-data-server-gtk4
    libical
    gtk3
    gtk4
    libadwaita
    gdm
    geoclue2
    adwaita-icon-theme
    gnome-bluetooth
    gnome-clocks # schemas needed
    at-spi2-core
    upower
    ibus
    gnome-desktop
    gnome-settings-daemon
    mesa

    # recording
    pipewire
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good

    # not declared at build time, but typelib is needed at runtime
    libgweather
    libnma-gtk4

    # for gnome-extension tool
    bash-completion
    gnome-autoar
    json-glib

    # for tools
    pythonEnv
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dtests=false"
  ];

  postPatch = ''
    patchShebangs src/data-to-c.pl

    # We can generate it ourselves.
    rm -f man/gnome-shell.1
    rm data/theme/gnome-shell-{light,dark}.css
  '';

  postInstall = ''
    # Pull in WebP and JXL support for gnome-backgrounds.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
      extraLoaders = [
        libjxl
        librsvg
        webp-pixbuf-loader
      ];
    }}"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Until glib’s xdgmime is patched
      # Fixes “Failed to load resource:///org/gnome/shell/theme/noise-texture.png: Unrecognized image file format”
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = ''
    # The services need typelibs.
    for svc in org.gnome.ScreenSaver org.gnome.Shell.Extensions org.gnome.Shell.Notifications org.gnome.Shell.Screencast; do
      wrapGApp $out/share/gnome-shell/$svc
    done

    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
    updateScript = gnome.updateScript {
      packageName = "gnome-shell";
      attrPath = "gnome.gnome-shell";
    };
  };

  meta = with lib; {
    description = "Core user interface for the GNOME 3 desktop";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-shell";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };

})
