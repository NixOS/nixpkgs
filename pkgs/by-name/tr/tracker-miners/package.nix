{ stdenv
, lib
, fetchurl
, asciidoc
, docbook-xsl-nons
, docbook_xml_dtd_45
, gettext
, itstool
, libxslt
, gexiv2
, tracker
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, vala
, wrapGAppsNoGuiHook
, bzip2
, dbus
, exempi
, giflib
, glib
, gobject-introspection
, gnome
, gst_all_1
, icu
, json-glib
, libcue
, libexif
, libgsf
, libgudev
, libgxps
, libiptcdata
, libjpeg
, libosinfo
, libpng
, libseccomp
, libtiff
, libuuid
, libxml2
, networkmanager
, poppler
, systemd
, taglib
, upower
, totem-pl-parser
, e2fsprogs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "localsearch";
  version = "3.8.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/localsearch/${lib.versions.majorMinor finalAttrs.version}/localsearch-${finalAttrs.version}.tar.xz";
    hash = "sha256-KPolJ/pOty5MBj3Jk1ydPQzvxB3O7HP8knQz3E7SBqk=";
  };

  patches = [
    ./tracker-landlock-nix-store-permission.patch
  ];

  nativeBuildInputs = [
    asciidoc
    docbook-xsl-nons
    docbook_xml_dtd_45
    gettext
    glib
    gobject-introspection
    itstool
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsNoGuiHook
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  # TODO: add libenca, libosinfo
  buildInputs = [
    bzip2
    dbus
    exempi
    giflib
    gexiv2
    totem-pl-parser
    tracker
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    icu
    json-glib
    libcue
    libexif
    libgsf
    libgudev
    libgxps
    libiptcdata
    libjpeg
    libosinfo
    libpng
    libtiff
    libuuid
    libxml2
    poppler
    taglib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libseccomp
    networkmanager
    systemd
    upower
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    e2fsprogs
  ];

  mesonFlags = [
    # TODO: tests do not like our sandbox
    "-Dfunctional_tests=false"
  ] ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    "-Dbattery_detection=none"
    "-Dnetwork_manager=disabled"
    "-Dsystemd_user_services=false"
  ];

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "localsearch";
      attrPath = "tracker-miners";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/localsearch";
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = lib.teams.gnome.members;
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "localsearch";
  };
})
