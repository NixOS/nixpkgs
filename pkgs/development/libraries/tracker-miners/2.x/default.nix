{ stdenv
, fetchurl
, substituteAll
, intltool
, itstool
, libxslt
, gexiv2
, tracker_2
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
, poppler
, taglib
, upower
, totem-pl-parser
}:

stdenv.mkDerivation rec {
  pname = "tracker-miners";
  version = "2.3.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "06abxrnrz7xayykrabn135rpsm6z0fqw7gibrb9j09l6swlalwkl";
  };

  nativeBuildInputs = [
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
    tracker_2
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
    poppler
    taglib
    upower
  ];

  mesonFlags = [
    # TODO: tests do not like our sandbox
    "-Dfunctional_tests=false"
    "-Ddbus_services=${placeholder "out"}/share/dbus-1/services"
    "-Dsystemd_user_services=${placeholder "out"}/lib/systemd/user"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tracker_2;
    })
    # https://bugzilla.gnome.org/show_bug.cgi?id=795576
    (fetchurl {
      url = "https://bugzilla.gnome.org/attachment.cgi?id=371427";
      sha256 = "187flswvzymjfxwfrrhizb1cvs780zm39aa3i2vwa5fbllr7kcpf";
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
