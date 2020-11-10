{ stdenv
, fetchurl
, substituteAll
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
, pkgconfig
, vala
, wrapGAppsHook
, bzip2
, dbus
, evolution-data-server
, exempi
, giflib
, glib
, gnome3
, gst_all_1
, icu
, json-glib
, libcue
, libexif
, libgrss
, libgsf
, libgxps
, libiptcdata
, libjpeg
, libosinfo
, libpng
, libseccomp
, libsoup
, libtiff
, libuuid
, libxml2
, networkmanager
, poppler
, systemd
, taglib
, upower
, totem-pl-parser
}:

stdenv.mkDerivation rec {
  pname = "tracker-miners";
  version = "3.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1kfi5d6pccqx28hbnja6k1mpwjd53k5zs704sg01rlzmbshz1zn6";
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
    pkgconfig
    vala
    wrapGAppsHook
  ];

  # TODO: add libenca, libosinfo
  buildInputs = [
    bzip2
    dbus
    evolution-data-server
    exempi
    giflib
    glib
    gexiv2
    totem-pl-parser
    tracker
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    icu
    json-glib
    libcue
    libexif
    libgrss
    libgsf
    libgxps
    libiptcdata
    libjpeg
    libosinfo
    libpng
    libseccomp
    libsoup
    libtiff
    libuuid
    libxml2
    networkmanager
    poppler
    systemd
    taglib
    upower
  ];

  mesonFlags = [
    # TODO: tests do not like our sandbox
    "-Dfunctional_tests=false"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit asciidoc;
    })
  ];

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/Tracker";
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
