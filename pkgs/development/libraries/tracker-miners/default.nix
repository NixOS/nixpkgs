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

stdenv.mkDerivation rec {
  pname = "tracker-miners";
  version = "3.4.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "EB42CPHCi/7YriVSL3pyC1WfiJp24oCvvlCk2LBk+Sw=";
  };

  nativeBuildInputs = [
    asciidoc
    docbook-xsl-nons
    docbook_xml_dtd_45
    gettext
    itstool
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsNoGuiHook
  ];

  # TODO: add libenca, libosinfo
  buildInputs = [
    bzip2
    dbus
    exempi
    giflib
    glib
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
  ] ++ lib.optionals stdenv.isLinux [
    libseccomp
    networkmanager
    systemd
    upower
  ] ++ lib.optionals stdenv.isDarwin [
    e2fsprogs
  ];

  mesonFlags = [
    # TODO: tests do not like our sandbox
    "-Dfunctional_tests=false"

    # libgrss is unmaintained and has no new releases since 2015, and an open
    # security issue since then. Despite a patch now being availab, we're opting
    # to be safe due to the general state of the project
    "-Dminer_rss=false"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-Dnetwork_manager=disabled"
    "-Dsystemd_user_services=false"
  ];

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Tracker";
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
