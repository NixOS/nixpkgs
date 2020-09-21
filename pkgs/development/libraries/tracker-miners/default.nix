{ stdenv
, fetchurl
, substituteAll
, asciidoc
, docbook_xsl
, docbook_xml_dtd_45
, intltool
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
, flac
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
, libvorbis
, libxml2
, networkmanager
, poppler
, taglib
, upower
, totem-pl-parser
}:

stdenv.mkDerivation rec {
  pname = "tracker-miners";
  version = "3.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hj0ixrladm7sxcmi0hr6d7wdlg9zcq0cyk22prg9pn54dy1lj5v";
  };

  nativeBuildInputs = [
    asciidoc
    docbook_xsl
    docbook_xml_dtd_45
    intltool
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
    flac
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
    libvorbis
    libxml2
    networkmanager
    poppler
    taglib
    upower
  ];

  mesonFlags = [
    # TODO: tests do not like our sandbox
    "-Dfunctional_tests=false"
    "-Ddbus_services_dir=${placeholder "out"}/share/dbus-1/services"
    "-Dsystemd_user_services=true"
    "-Dsystemd_user_services_dir=${placeholder "out"}/lib/systemd/user"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit asciidoc tracker;
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
