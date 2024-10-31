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
, gnome
, gst_all_1
, icu
, json-glib
, libcue
, libexif
, libgsf
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
  pname = "tracker-miners";
  version = "3.7.3";

  src = fetchurl {
    url = "mirror://gnome/sources/tracker-miners/${lib.versions.majorMinor finalAttrs.version}/tracker-miners-${finalAttrs.version}.tar.xz";
    hash = "sha256-50OIFUtcGXtLfuQvDc6MX7vd1NNhCT74jU+zA+M9pf4=";
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

    # libgrss is unmaintained and has no new releases since 2015, and an open
    # security issue since then. Despite a patch now being availab, we're opting
    # to be safe due to the general state of the project
    "-Dminer_rss=false"
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
      packageName = "tracker-miners";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/tracker-miners";
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = lib.teams.gnome.members;
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
